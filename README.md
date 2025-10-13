<div align="center">
    <a href="https://github.com/picsou83/compta.libremen.com">
        <img width="100" height="100" src="https://user-images.githubusercontent.com/34648108/190251291-28a32777-ad26-4362-8a75-eb41a94c7be3.png">
    </a> 
    <br>
    <br>
    <div style="display: flex;">
    <a href="https://github.com/picsou83/compta.libremen.com/releases">
        <img src="https://img.shields.io/github/release/picsou83/compta.libremen.com.svg">
    </a>
    <a href="https://hub.docker.com/repository/docker/picsou83/compta-libremen-com">
        <img src="https://img.shields.io/badge/docker%20image-latest-brightgreen">
    </a>
    </div>   
        <h1>compta.libremen.com</h1>
    <p>
 </div> 

**compta.libremen.com** est un logiciel libre et gratuit de comptabilité en partie double permettant d'enregistrer des écritures comptables de façon aisée, rapide et fiable

Il offre les fonctions de base nécessaires à la génération des documents courants (journal général, plan comptable, grand livre, balance...) et des fonctions d'exportation des données permettant leur traitement par d'autres logiciels du système d'information de l'entreprise (format FEC)

La version initiale (1.0) de ce logiciel est disponible sur le site https://compta.libremen.com/ 

La version disponible ici est une **version modifiée** avec de nouvelles fonctionnalités et packagée pour un déploiement rapide via docker. (Debian avec  Apache + Mod_perl + PostgreSQL)

********************************************************************************************************
Vous pouvez tester le logiciel sur l'instance de test ci-dessous (username superadmin password: admin) :
http://141.145.216.88/base/
********************************************************************************************************

## Fork et modifications

Ce dépôt contient un **fork** indépendant du logiciel original développé par Vincent Veyron ([site officiel](https://compta.libremen.com/)).  

Cette version inclut plusieurs **ajouts et améliorations** :
- Module gestion de documents
- Module Écritures récurrentes
- Module Bilan avec gestion des formules de calcul des formulaires
- Module Notes de frais avec génération des écritures et impression PDF
- Module Intérêts CCA
- Documentation intégrée
- Module Analyses : détection des anomalies comptables
- Impression PDF de la balance et du grand livre
- Module Saisie rapide d’écritures
- Module Recherche d’écritures
- Module Importation via OCR et fichiers CSV
- Module Gestion Email
- Module Gestion immobilière : gestion des baux, des logements et génération des quittances
- Saisie facile : saisie rapide d’une tâche comptable 
- Docker et déploiement : pack Docker prêt à l’emploi

**Attention :**  
- Nous **ne sommes pas associés** au projet original.  
- Certaines **nouveautés ajoutées dans le logiciel officiel de Vincent Veyron** peuvent **ne pas être présentes** dans ce fork.  
- Utilisez le Docker fourni avec précaution.

## [Bien démarrer](https://github.com/picsou83/compta.libremen.com/wiki/Home)
Le [WIKI](https://github.com/picsou83/compta.libremen.com/wiki) vous fournit toutes les informations nécessaires pour être opérationnel!.

* [Home](https://github.com/picsou83/compta.libremen.com/wiki/Home)
  * [Installation](https://github.com/picsou83/compta.libremen.com/wiki/Home)
    * [Cloud => Installation gratuite](https://github.com/picsou83/compta.libremen.com/wiki/Cloud-installation-gratuite)
    * [Linux => Installation Hub Docker](https://github.com/picsou83/compta.libremen.com/wiki/Linux-installation-Hub-Docker)
    * [Linux => Installation Dockerfile](https://github.com/picsou83/compta.libremen.com/wiki/Linux-installation-Dockerfile)
    * [Linux => Installation manuelle](https://github.com/picsou83/compta.libremen.com/wiki/Linux-installation-manuelle)
    * [Windows => Installation via WSL](https://github.com/picsou83/compta.libremen.com/wiki/Windows-installation-WSL)
  * [Mise à jour](https://github.com/picsou83/compta.libremen.com/wiki/Home)
    * [Linux => Maj image Docker](https://github.com/picsou83/compta.libremen.com/wiki/Linux-Maj-Docker)
    * [Linux => Maj manuelle ](https://github.com/picsou83/compta.libremen.com/wiki/Linux-Maj-manuelle)
    * [Windows => Maj image WSL](https://github.com/picsou83/compta.libremen.com/wiki/Windows-Maj-WSL)
    * [Windows => Maj manuelle](https://github.com/picsou83/compta.libremen.com/wiki/Windows-Maj-manuelle)
  * [Configuration](https://github.com/picsou83/compta.libremen.com/wiki/Home)
* [Identifiants & Tips](https://github.com/picsou83/compta.libremen.com/wiki/Identifiants-&-Tips)
* [Screenshot](https://github.com/picsou83/compta.libremen.com/wiki/Screenshot)
* [Roadmap](https://github.com/picsou83/compta.libremen.com/wiki/Roadmap)

## Aide et Support
Si vous avez besoin d'aide, vous pouvez utiliser le [salon de discussions](https://github.com/picsou83/compta.libremen.com/discussions) et pour les bugs vous pouvez utiliser les [issues](https://github.com/picsou83/compta.libremen.com/issues).

## Licence

Ce logiciel est une **version modifiée** d’un logiciel libre initialement développé par Vincent Veyron.  
Il est distribué sous la **licence CeCILL-C**. Vous pouvez utiliser, modifier et redistribuer ce logiciel conformément aux termes de cette licence.  
Pour plus d’informations : [http://www.cecill.info](http://www.cecill.info)

**Avertissement :** En accord avec la licence CeCILL-C, ce logiciel est fourni avec une garantie limitée. L’utilisateur assume les risques liés à son utilisation. Ni l’auteur initial, ni le modificateur ne peuvent être tenus responsables de dommages directs ou indirects.
