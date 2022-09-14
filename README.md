# compta.libremen.com 

<a href="https://github.com/picsou83/compta.libremen.com/releases">

compta.libremen.com est un logiciel de comptabilité en partie double permettant d'enregistrer des écritures comptables de façon aisée, rapide et fiable

Il offre les fonctions de base nécessaires à la génération des documents courants (journal général, plan comptable, grand livre, balance...) et des fonctions d'exportation des données permettant leur traitement par d'autres logiciels du système d'information de l'entreprise

Ce logiciel est régi par la licence CeCILL-C soumise au droit français et respectant les principes de diffusion des logiciels libres. Vous pouvez utiliser, modifier et/ou redistribuer ce programme sous les conditions de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA sur le site "http://www.cecill.info".

## Sommaire

- [Docker Images via le Hub Docker](#docker-images-via-le-hub-docker)
- [Docker Images via Dockerfile](#docker-images-via-Dockerfile)
- [Installation manuelle](#Installation-manuelle)

## Docker Images via le Hub Docker

1) Installation de Docker :

Docker est maintenant disponible sur toutes les distributions récentes. Pour l’installer sur une distribution

- à base de rpm
```
yum install docker
```
- à base de deb
```
apt-get update
apt-get install docker.io
```

2) Installation de l’image compta-libremen-com:

l'image est composée de debian + apache + perl + PostgreSQL + compta.libremen.com

```
docker pull picsou83/compta-libremen-com:latest
```

3) Lancement de l'image :

```
sudo docker run -i --name comptalibremen -t -v comptalibremen_app:/var/www/html/Compta/ -v comptalibremen_bdd:/var/lib/postgresql/ -d -p 8080:80 compta-libremen-com
```

Avec :

- comptalibremen : nom du Docker voulu
- comptalibremen_app et comptalibremen_bdd : répertoire où les données de compta-libremen-com sont mises sur l’hôte (par défaut /var/lib/docker/volumes/)

4) Récupération de l’adresse IP du conteneur

```
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' comptalibremen
172.17.0.2
```

5) Enjoys

* [http://172.17.0.X](http://172.17.0.X/)

identifiants *(mot de passe)*
-------------------------------------------
-  SSH: username **root** password: **comptalibre**
-  PostgreSQL, Adminer: username **compta** password: **compta** dbname : **comptalibre** 
-  comptalibremen: username **superadmin** password: **admin**

## Docker Images via Dockerfile


## Installation manuelle
