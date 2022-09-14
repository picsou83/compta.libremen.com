# compta.libremen.com 

compta.libremen.com est un logiciel de comptabilité en partie double permettant d'enregistrer des écritures comptables de façon aisée, rapide et fiable

Il offre les fonctions de base nécessaires à la génération des documents courants (journal général, plan comptable, grand livre, balance...) et des fonctions d'exportation des données permettant leur traitement par d'autres logiciels du système d'information de l'entreprise

Ce logiciel est régi par la licence CeCILL-C soumise au droit français et respectant les principes de diffusion des logiciels libres. Vous pouvez utiliser, modifier et/ou redistribuer ce programme sous les conditions de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA sur le site "http://www.cecill.info".

## Sommaire

- [Docker Images via le Hub Docker](#docker-images-via-le-hub-docker)
- [Docker Images via Dockerfile](#docker-images-via-Dockerfile)
- [Docker commandes](#docker-commandes)
- [Installation manuelle](#Installation-manuelle)

## Docker Images via le Hub Docker

1) Installation de Docker :

Docker est maintenant disponible sur toutes les distributions récentes. Pour l’installer sur une distribution

- à base de rpm
```yum install docker```
- à base de deb
```apt-get update
apt-get install docker.io```

2) Installation de l’image compta-libremen-com (debian + apache + perl + PostgreSQL):

```docker pull picsou83/compta-libremen-com:latest```

3) Lancement de l'image :

```sudo docker run -i --name comptalibremen -t -v rep_app:/var/www/html/Compta/ -v rep_bdd:/var/lib/postgresql/ -d picsou83/compta-libremen-com:first```

Avec :

- comptalibremen : nom du Docker voulu
- rep_app et rep_bdd : répertoire où les données de compta-libremen-com sont mises sur l’hôte (par défaut /var/lib/docker/volumes/)

4) Récupération de l’adresse IP du conteneur

```sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' comptalibremen```

5) Enjoys

* [http://172.17.0.X](http://172.17.0.X/)

identifiants *(mot de passe)*
-------------------------------------------
-  SSH: username **root** password: **comptalibre**
-  PostgreSQL, Adminer: username **compta** password: **compta** dbname : **comptalibre** 
-  comptalibremen: username **superadmin** password: **admin**

## Docker Images via Dockerfile

## Docker commandes
```sh
$ docker ps # Visualiser les conteneurs actifs
$ docker ps -a # Visualiser tous les conteneurs
$ docker rm [container] # Supprimer un conteneur inactif
$ docker rm -f [container] # Forcer la suppression d'un conteneur actif
$ docker images # Lister les images existantes
$ docker rmi [image] # Supprimer une image docker
$ docker exec -t -i [container] /bin/bash # Exécuter des commandes dans un conteneur actif
$ docker inspect [container] # Inspecter la configuration d'un conteneur
$ docker build -t [image] . # Construire une image à partir d'un Dockerfile
$ docker history [image] # Visualiser l'ensemble des couches d'une image
$ docker logs --tail 5 [container] # Visualiser les logs d'un conteneur (les 5 dernières lignes)

# Intéractions avec le registry
$ docker login # Se connecter au registry
$ docker search [name] # Rechercher une image
$ docker pull [image] # Récupérer une image
$ docker push [image] # Pouser une image du cache local au registry
$ docker tag [UUID] [image]:[tag] # Tagger une image
```


## Installation manuelle


