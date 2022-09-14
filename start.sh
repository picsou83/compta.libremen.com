#!/usr/bin/env bash

echo "modification des droits postgres"
sudo chown -R postgres /var/lib/postgresql/ 

echo "modification des droits apache"
sudo chown -R www-data:www-data /var/www/
sudo chmod 755 -R /var/www/
