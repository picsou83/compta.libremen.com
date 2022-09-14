# compta.libremen.com via docker (debian + apache + perl + PostgreSQL)
[![GitHub release]

- [Docker images](#docker-images)
- [installer manuellement compta-libremen-com](#installer-manuellement-compta-libremen-com)

## Docker Images

1) Installation de Docker
Docker est maintenant disponible sur toutes les distributions récentes. Pour l’installer sur une distribution

- à base de rpm
yum install docker

- à base de deb
apt-get update
apt-get install docker.io


2) Installation de l’image compta-libremen-com:

docker pull picsou83/compta-libremen-com:latest


3) Lancement de l'image :

sudo docker run -i --name comptalibremen -t -v comptalibremen_app:/var/www/html/Compta/ -v comptalibremen_bdd:/var/lib/postgresql/ -d -p 8080:80 compta-libremen-com

Avec :

comptalibremen : nom du Docker voulu
comptalibremen_app et comptalibremen_bdd : répertoire où les données de compta-libremen-com sont mises sur l’hôte (par défaut /var/lib/docker/volumes/)

4) Récupération de l’adresse IP du conteneur

sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' comptalibremen
172.17.0.2

5) Enjoys

* [http://172.17.0.X](http://172.17.0.X/)

identifiants *(mot de passe)*
-------------------------------------------
-  SSH: username **root** password: **comptalibre**
-  PostgreSQL, Adminer: username **compta** password: **compta** dbname : **comptalibre** 
-  comptalibremen: username **superadmin** password: **admin**


## installer manuellement compta-libremen-com
