#!/bin/bash

# Verify the script is being called from entrypoint.sh
if [ -z "$guacamole_version" ] || [ -z "$guacamole_location" ] || [ -z "$script_path" ]; then
    echo "$(date "+%F %T") guacamole-install must be called via entrypoint.sh."
    exit 1
fi

# Update package lists
apt-get update

# Ubuntu and Debian have different package names for libjpeg
# Ubuntu and Debian versions have differnet package names for libpng-dev
# Ubuntu 18.04 does not include universe repo by default
source /etc/os-release
if [[ "${NAME}" == "Ubuntu" ]]
then
    JPEGTURBO="libjpeg-turbo8-dev"
    if [[ "${VERSION_ID}" == "18.04" ]]
    then
        sed -i 's/bionic main$/bionic main universe/' /etc/apt/sources.list
    fi
    if [[ "${VERSION_ID}" == "16.04" ]]
    then
        LIBPNG="libpng12-dev"
    else
        LIBPNG="libpng-dev"
    fi
elif [[ "${NAME}" == *"Debian"* ]]
then
    JPEGTURBO="libjpeg62-turbo-dev"
    if [[ "${PRETTY_NAME}" == *"stretch"* ]]
    then
        LIBPNG="libpng-dev"
    else
        LIBPNG="libpng12-dev"
    fi
else
    echo "$(date "+%F %T") Unsupported Distro - Ubuntu or Debian Only."
    exit 1
fi

# Update apt so we can search apt-cache for newest tomcat version supported
apt-get -qq update

# Tomcat 8.0.x is End of Life, however Tomcat 7.x is not...
# If Tomcat 8.5.x or newer is available install it, otherwise install Tomcat 7
# I have not testing with Tomcat9...
if [[ $(apt-cache show tomcat8 | egrep "Version: 8.[5-9]" | wc -l) -gt 0 ]]
then
    TOMCAT="tomcat8"
else
    TOMCAT="tomcat7"
fi

# Install features
echo -e "Installing dependencies. This might take a few minutes..."

apt-get -y install build-essential libcairo2-dev ${JPEGTURBO} ${LIBPNG} libossp-uuid-dev libavcodec-dev libavutil-dev \
libswscale-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev \
libvorbis-dev libwebp-dev mysql-server mysql-client mysql-common mysql-utilities libmysql-java ${TOMCAT} freerdp-x11 \
ghostscript wget dpkg-dev

# Download Apache Guacamole server
if [ ! -f guacamole-server-${guacamole_version}.tar.gz ]; then
    wget -q --show-progress -O guacamole-server-${guacamole_version}.tar.gz ${guacamole_location}/source/guacamole-server-${guacamole_version}.tar.gz
    tar -xzf guacamole-server-${guacamole_version}.tar.gz
fi
 
# Download Apache Guacamole client
if [ ! -f guacamole-${guacamole_version}.war ]; then
    wget -q --show-progress -O guacamole-${guacamole_version}.war ${guacamole_location}/binary/guacamole-${guacamole_version}.war
fi

# Download authentication extension
if [ ! -f guacamole-auth-jdbc-${guacamole_version}.tar.gz ]; then
    wget -q --show-progress -O guacamole-auth-jdbc-${guacamole_version}.tar.gz ${guacamole_location}/binary/guacamole-auth-jdbc-${guacamole_version}.tar.gz
    tar -xzf guacamole-auth-jdbc-${guacamole_version}.tar.gz
fi

# Make directories 
mkdir -p /etc/guacamole/lib
mkdir -p /etc/guacamole/extensions

# Install guacd
echo -e "Building Guacamole with GCC $(gcc --version | head -n1 | grep -oP '\)\K.*' | awk '{print $1}') "
cd guacamole-server-${guacamole_version}

echo -e "Configuring..."
./configure --with-init-dir=/etc/init.d   

echo -e "Running Make. This might take a few minutes..."
make  


echo -e "Running Make Install..."
make install
cd ..

ldconfig
systemctl enable guacd
service guacd start

# Get build-folder
BUILD_FOLDER=$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)

# Move files to correct locations
mv guacamole-${guacamole_version}.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/${TOMCAT}/webapps/
ln -s /usr/local/lib/freerdp/guac*.so /usr/lib/${BUILD_FOLDER}/freerdp/
ln -s /usr/share/java/mysql-connector-java.jar /etc/guacamole/lib/
cp guacamole-auth-jdbc-${guacamole_version}/mysql/guacamole-auth-jdbc-mysql-${guacamole_version}.jar /etc/guacamole/extensions/

# restart tomcat
echo -e "Restarting tomcat..."

service ${TOMCAT} restart


