

<div align="center">
    <a href="https://github.com/picsou83/compta.libremen.com">
        <img width="100" height="100" src="https://user-images.githubusercontent.com/34648108/190251291-28a32777-ad26-4362-8a75-eb41a94c7be3.png">
    </a>
 </div>


# compta.libremen.com v1.10

compta.libremen.com est un logiciel libre de comptabilité en partie double permettant d'enregistrer des écritures comptables de façon aisée, rapide et fiable

Il offre les fonctions de base nécessaires à la génération des documents courants (journal général, plan comptable, grand livre, balance...) et des fonctions d'exportation des données permettant leur traitement par d'autres logiciels du système d'information de l'entreprise

La version initiale (1.0) de ce logiciel est disponible sur le site https://compta.libremen.com/ 

La version disponible ici est une version modifiée avec de nouvelles fonctionnalités et packagée pour un déploiement rapide via docker.

Ce logiciel est régi par la licence CeCILL-C soumise au droit français et respectant les principes de diffusion des logiciels libres. Vous pouvez utiliser, modifier et/ou redistribuer ce programme sous les conditions de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA sur le site "http://www.cecill.info".

## Sommaire

- [Installation via le Hub Docker](#docker-images-via-le-hub-docker)
- [Installation via Dockerfile](#docker-images-via-Dockerfile)
- [Docker commandes](#docker-commandes)
- [Identifiants](#identifiants)
- [Tips](#tips)
- [Screenshot](#Screenshot)

## Installation via le Hub Docker

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

2) Installation de l’image compta-libremen-com (debian + apache + perl + PostgreSQL):
```
docker pull picsou83/compta-libremen-com:first
```

3) Lancement de l'image :
```
sudo docker run -i --name comptalibremen -t -v rep_app:/var/www/html/Compta/ -v rep_bdd:/var/lib/postgresql/ -d picsou83/compta-libremen-com:first
```
Avec :
- comptalibremen : nom du Docker voulu
- rep_app et rep_bdd : répertoire où les données sont mises sur l’hôte (par défaut /var/lib/docker/volumes/)

4) Récupération de l’adresse IP du conteneur
```
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' comptalibremen
```

5) Enjoys

* [http://172.17.0.X](http://172.17.0.X/)

## Installation via Dockerfile

1)  Télécharger les sources
https://github.com/picsou83/compta.libremen.com/archive/refs/heads/main.zip

2) Génération de l'image
- Se positionner dans le répertoire contenant les sources
- Lancer la commande :
```
docker build -t compta-libremen-com .
```
3) Lancement de l'image :
```
sudo docker run -i --name comptalibremen -t -v rep_app:/var/www/html/Compta/ -v rep_bdd:/var/lib/postgresql/ -d compta-libremen-com
```
Avec :

- comptalibremen : nom du Docker voulu
- rep_app et rep_bdd : répertoire où les données de compta-libremen-com sont mises sur l’hôte (par défaut /var/lib/docker/volumes/)

4) Récupération de l’adresse IP du conteneur
```
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' comptalibremen
```

5) Enjoys

* [http://172.17.0.X](http://172.17.0.X/)


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


## identifiants

-  SSH: username **root** password: **comptalibre**
-  PostgreSQL, Adminer: username **compta** password: **compta** dbname : **comptalibre** 
-  comptalibremen: username **superadmin** password: **admin**

## Tips

sous firefox il faut modifier un paramètre pour pouvoir ouvrir un pdf directement à travers le naviguateur:

menu => préférence => Général => #Applications

Portable Document Format(PDF) => ouvrir dans firefox

## Screenshot

![menu](https://user-images.githubusercontent.com/34648108/190163408-bc69fc56-8386-4b47-8014-bfbad673ada3.jpeg)

![journaux](https://user-images.githubusercontent.com/34648108/190163387-790ba81a-6bd7-4f79-a98b-2aeb22b0a4a8.jpeg)

![écriture](https://user-images.githubusercontent.com/34648108/190164057-300d0337-c744-4b7f-a80f-fb5a8ee1b239.jpeg)

![balance](https://user-images.githubusercontent.com/34648108/190163375-a69ef6f3-8cab-4bdc-9f91-d8f4f21005ae.jpeg)

![bilan](https://user-images.githubusercontent.com/34648108/190163359-00062b30-486f-4bac-a427-1a4c47325073.jpeg)








