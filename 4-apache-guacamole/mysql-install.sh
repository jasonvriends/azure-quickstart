#!/bin/bash

# Verify the script is being called from entrypoint.sh
if [ -z "$guacamole_version" ] || [ -z "$guacamole_location" ] || [ -z "$script_path" ]; then
    echo "$(date "+%F %T") mysql-install must be called via entrypoint.sh."
    exit 1
fi

# Read script arguments
while [ "$1" != "" ]; do
    case $1 in
        --help )                help
                                ;;
        --mysql-root-pwd )      shift 
                                mysql_root_pwd="$1"
                                ;;
        --mysql-db-name )       shift 
                                mysql_db_name="$1"
                                ;;
        --mysql-db-user )       shift 
                                mysql_db_user="$1"
                                ;;
        --mysql-db-user-pwd )   shift 
                                mysql_db_user_pwd="$1"
                                ;;
    esac
    shift
done

# Check for empty positional parameters
if [ -z "$mysql_root_pwd" ] || [ -z "$mysql_db_name" ] || [ -z "$mysql_db_user" ] || [ -z "$mysql_db_user_pwd" ]; then
    echo "$(date "+%F %T") --mysql-root-pwd and/or --mysql-db-name and/or --mysql-db-user and/or --mysql-db-user-pwd empty."
    exit 1
fi

# mySQL
export DEBIAN_FRONTEND=noninteractive
echo mysql-server mysql-server/root_password password $mysql_root_pwd | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $mysql_root_pwd | debconf-set-selections

## Install mySQL packages
apt-get install mysql-server mysql-client mysql-common mysql-utilities -y

## Create user
sql_query="create user '$mysql_db_user'@'localhost' identified by '$mysql_db_user_pwd';"
echo $sql_query | mysql -u root -p"$mysql_root_pwd"

## Create database
sql_query="create database $mysql_db_name;"
echo $sql_query | mysql -u root -p"$mysql_root_pwd"

## Grant the user privileges to the database
sql_query="GRANT SELECT,INSERT,UPDATE,DELETE ON $mysql_db_name.* TO $mysql_db_user@localhost; flush privileges;"
echo $sql_query | mysql -u root -p"$mysql_root_pwd"

## apply database schema

### download jdbc authentication extension
if [ ! -f guacamole-auth-jdbc-${guacamole_version}.tar.gz ]; then
    wget -q --show-progress -O guacamole-auth-jdbc-${guacamole_version}.tar.gz ${guacamole_location}/binary/guacamole-auth-jdbc-${guacamole_version}.tar.gz
fi 

### Extract database schema
tar -xzf guacamole-auth-jdbc-${guacamole_version}.tar.gz

### Apply database schema
cat guacamole-auth-jdbc-${guacamole_version}/mysql/schema/*.sql | mysql -u root -p"$mysql_root_pwd" "$mysql_db_name"

### Create Desktop connection within guacamole
mysql -u root -p"$mysql_root_pwd" < create-guac-connection.sql

# Configure guacamole.properties
mkdir -p /etc/guacamole
echo "mysql-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "mysql-port: 3306" >> /etc/guacamole/guacamole.properties
echo "mysql-database: ${mysql_db_name}" >> /etc/guacamole/guacamole.properties
echo "mysql-username: ${mysql_db_user}" >> /etc/guacamole/guacamole.properties
echo "mysql-password: ${mysql_db_user_pwd}" >> /etc/guacamole/guacamole.properties
