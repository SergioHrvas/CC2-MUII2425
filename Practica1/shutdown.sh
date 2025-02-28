#!/bin/bash

echo "Deteniendo contenedores..."
podman stop owncloud mariadb redis openldap-server
echo "Todos los contenedores han sido detenidos."