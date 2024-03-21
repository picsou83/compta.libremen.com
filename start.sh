#!/usr/bin/env bash

echo "Extraction du fichier de mise à jour"
tar -xpzf /tmp/comptalibre-server.tar.gz -C / --keep-newer-files > /dev/null 2>&1

echo "Modification des droits postgres"
chown -R postgres /var/lib/postgresql/

echo "Modification des droits apache"
chown -R www-data:www-data /var/www/
chmod 755 -R /var/www/

