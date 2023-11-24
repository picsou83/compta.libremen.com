#!/usr/bin/env bash

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
echo "Change owner database to compta..."
sudo -u postgres psql -U postgres -c "ALTER DATABASE ${DBNAME} owner TO compta"

echo "+----------------------------------------------------------+"
echo "|           			 Database ok ;-)    	    	     |"
echo "|      											         |"
echo "+----------------------------------------------------------+"
echo
