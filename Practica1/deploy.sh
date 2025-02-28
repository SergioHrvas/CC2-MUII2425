#!/bin/bash

echo "Iniciando contenedores..."

# Iniciar OpenLDAP
podman start openldap-server || podman run -p 389:389 -p 636:636 \
    --volume /home/sergio/Documentos/Master/CC-2/Practica1/volume_ldap/data/slapd/database:/var/lib/ldap \
    --volume /home/sergio/Documentos/Master/CC-2/Practica1/volume_ldap/data/slapd/config:/etc/ldap/slapd.d \
    --name openldap-server  --detach osixia/openldap:1.5.0

# Iniciar Redis con persistencia
podman start redis || podman run -d --name redis \
    -p 6379:6379 \
    -v /home/sergio/Documentos/Master/CC-2/Practica1/volume_redis:/data \
    redis redis-server --save 60 1 --loglevel warning

# Iniciar MariaDB
podman start mariadb || podman run --detach --name mariadb \
    -v /home/sergio/Documentos/Master/CC-2/Practica1/volume_mariadb/MariaDB_data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD="passwordroot" \
    -e MYSQL_DATABASE="owncloud_db" \
    -e MYSQL_USER="usuario" \
    -e MYSQL_PASSWORD="password" \
    mariadb:latest

# Iniciar OwnCloud
podman start owncloud || podman run -d --name owncloud \
    -p 80:80 owncloud:latest \
    -v /home/sergio/Documentos/Master/CC-2/Practica1/volume_owncloud:/var/www/html/data

echo "Todos los contenedores han sido iniciados."
