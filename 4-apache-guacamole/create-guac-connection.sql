INSERT INTO guacamole_connection (connection_name, protocol) VALUES ('desktop-vm', 'rdp');

SET @id = LAST_INSERT_ID();

INSERT INTO guacamole_connection_parameter VALUES (@id, 'hostname', 'desktop-vm');
INSERT INTO guacamole_connection_parameter VALUES (@id, 'username','vmadmin');
INSERT INTO guacamole_connection_parameter VALUES (@id, 'password','!Canada2019!');
INSERT INTO guacamole_connection_parameter VALUES (@id, 'port', '3389');
INSERT INTO guacamole_connection_parameter VALUES (@id, 'security', 'any');
INSERT INTO guacamole_connection_parameter VALUES (@id, 'ignore-cert', 'true');