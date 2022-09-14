#!/usr/bin/env bash

sudo tar -xpzf /tmp/comptalibre-server.tar.gz -C / --keep-newer-files

echo "Démarrage de postgresql ..."
service postgresql start 

echo "Création de l'utilisateur compta ... "
sudo -u postgres psql -U postgres -c "CREATE USER "compta" WITH CREATEDB PASSWORD 'compta'"
echo "Création de la database compta ..."
sudo -u postgres psql -U postgres -c "CREATE DATABASE ${DBNAME}"
echo "Restauration du dump ..."
sudo -u postgres psql -v "postgresql://compta:compta@localhost/" -d "${DBNAME}" < "/tmp/compta.sql"
echo "Modification des droits sur la database ..."
sudo -u postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE ${DBNAME} TO postgres"

echo "+----------------------------------------------------------+"
echo "|           			 Database ok ;-)    	    	     |"
echo "|      											         |"
echo "+----------------------------------------------------------+"
echo
