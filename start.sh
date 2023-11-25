#!/usr/bin/env bash

echo "Extraction du fichier de mise à jour"
tar -xpzf /tmp/comptalibre-server.tar.gz -C / --keep-newer-files

echo "Modification des droits postgres"
sudo chown -R postgres /var/lib/postgresql/

echo "Modification des droits apache"
sudo chown -R www-data:www-data /var/www/
sudo chmod 755 -R /var/www/
