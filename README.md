

<div align="center">
    <a href="https://github.com/picsou83/compta.libremen.com">
        <img width="100" height="100" src="https://user-images.githubusercontent.com/34648108/190251291-28a32777-ad26-4362-8a75-eb41a94c7be3.png">
    </a> 
 </div> 

# compta.libremen.com

compta.libremen.com est un logiciel libre et gratuit de comptabilité en partie double permettant d'enregistrer des écritures comptables de façon aisée, rapide et fiable

Il offre les fonctions de base nécessaires à la génération des documents courants (journal général, plan comptable, grand livre, balance...) et des fonctions d'exportation des données permettant leur traitement par d'autres logiciels du système d'information de l'entreprise

La version initiale (1.0) de ce logiciel est disponible sur le site https://compta.libremen.com/ 

La version disponible ici est une version modifiée avec de nouvelles fonctionnalités et packagée pour un déploiement rapide via docker. (Debian avec  Apache + Mod_perl + PostgreSQL)

## [Bien démarrer](https://github.com/picsou83/compta.libremen.com/wiki)
Le [wiki](https://github.com/picsou83/compta.libremen.com/wiki) vous fournit toutes les informations nécessaires pour être opérationnel!.


## Sommaire
- [Screenshot](#Screenshot)
- [Wiki](https://github.com/picsou83/compta.libremen.com/wiki)
- [Linux => Installation via le Hub Docker](https://github.com/picsou83/compta.libremen.com/wiki/Linux_installation_Hub_Docker)
- [Linux => Installation via Dockerfile](https://github.com/picsou83/compta.libremen.com/wiki/Linux_installation_Dockerfile)
- [Linux => Installation manuelle]([#linux--installation-manuelle](https://github.com/picsou83/compta.libremen.com/wiki/Linux_installation_manuelle))
- [Windows => Installation via WSL]([#windows--installation-via-wsl](https://github.com/picsou83/compta.libremen.com/wiki/Windows_installation_WSL))
- [Docker commandes](#docker-commandes)
- [Identifiants](#identifiants)
- [Tips](#tips)


## Screenshot

![menu](https://user-images.githubusercontent.com/34648108/190163408-bc69fc56-8386-4b47-8014-bfbad673ada3.jpeg)

![journaux](https://user-images.githubusercontent.com/34648108/190163387-790ba81a-6bd7-4f79-a98b-2aeb22b0a4a8.jpeg)

![écriture](https://user-images.githubusercontent.com/34648108/190164057-300d0337-c744-4b7f-a80f-fb5a8ee1b239.jpeg)

![balance](https://user-images.githubusercontent.com/34648108/190163375-a69ef6f3-8cab-4bdc-9f91-d8f4f21005ae.jpeg)

![bilan](https://user-images.githubusercontent.com/34648108/190163359-00062b30-486f-4bac-a427-1a4c47325073.jpeg)


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









