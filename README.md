# Installation automatique de JupyterHub via docker

**JupyterHub** est un outil permettant d'ajouter une fonctionnalité multi-utilisateurs à Jupyter. nbgrader s'intègre à cette configuration afin de rendre automatique la soumission et la récupération des travaux. Il nécessite par contre l'utilisation dans le lycée d'un serveur hébergeant la solution. Disposer d'un tel outil permet d'éviter d'avoir à installer jupyter en local car un accès distant via le navigateur suffit.

**Docker** est un outil de virtualisation d'application léger et très performant. Il permet de bénéficier d'un environnement jupyterhub indépendant du reste du système.

La procédure d'installation est la suivante :
1. Récupérez le matériel nécessaire à la fabrication de l'image Docker
```console
git clone https://github.com/wawachief/jupyterhubDocker.git
```
2. Installez docker sur votre machine. Sous linux, tapez simplement
```console
apt-get install docker.io
```
docker.io est la version de docker packagée par debian/ubuntu. Si vous rencontrez des difficultés avec cette version, vous pouvez utiliser la version officielle docker-ce dont l'installation est décrite ici :

https://www.digitalocean.com/community/tutorials/comment-installer-et-utiliser-docker-sur-ubuntu-18-04-fr

Utiliser une ou l'autre de ces versions ne changera rien pour la suite.

3. Allez dans le dossier *jupyterhub* et construisez votre image Docker
```console
cd jupyterhubDocker
docker build -t jhub_srv .
```
N'oubliez pas le . à la fin de la seconde commande !

4. Lancez votre image
```console
docker run -i -p8000:8000 --name jupyterhub jhub_srv
```

Le serveur **jupyterhub** est à présent opérationnel. Ouvrez un navigateur et allez à l'adresse
http://127.0.0.1:8000 (ou http://_votre_adresse_ip:8000 via le réseau). Vous pouvez commencer à tester un compte prof en utilisant les logins présents dans le fichier comptes.csv (par exemple prof1 / wawa)

## Gérer la persistance des données
Si vous mettez en place un serveur en production, vous voudrez que vos données survivent même si vous effacez le container pour en reconstruire un propre à partir d'une image. Les **volumes** docker sont vos amis ! Grâce à eux, vous pourrez externaliser le stockage de certains dossiers hors du container. Pour cette installation de jupyterhub, je recommande deux volumes 
- un volume pour les espaces personnels de stockage (jh_home)
- un volume pour la zone d'échange nbgrader (jh_exchange)

Pour créer ces deux volumes, tapez les commandes suivantes
```console
docker volume create jh_home
docker volume create jh_exchange
```

Pour créer un container utilisant ces volumes, il faut juste ajouter le paramètre 
  
  -v NOM_VOLUME:ARBO_DANS_CONTAINER :

```console
docker run -it --name jhub -p 8000:8000 -v jh_home:/home -v jh_exchange:/srv/nbgrader/exchange wawachief/jupyterhub
```

et voilà, en modifiant juste la ligne de création du container, vos données sont persistantes ! Vous pouvez effacer le container et en recréer un, vous retrouverez vos données. Vous avez maintenant un serveur opérationnel pour la production.

### Sauvegarde et restauration des données

Dans la commande ci-dessous, nous allons créer un nouveau container basé sur une ubuntu qui va accéder aux volumes de notre container nommé **jhub** et fabriquer une archive *tar* qui sera stockée dans le répertoire courant de la machine hôte. L'option **--rm** permet d'effacer ce container temporaire qui ne sert qu'à la récupération des données.
```console
docker run --rm --volumes-from jhub -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /home /srv/nbgrader/exchange
```
La ligne suivante va restaurer l'archive **backup.tar** réalisée ci-dessus d'un nouveau container **jhub_new** que l'on a déjà lancé.
```console
docker run --rm --volumes-from jhub_new -v $(pwd):/backup ubuntu bash -c "cd / && tar xvf /backup/backup.tar"
```
Ces deux méthodes montrent donc comment transférer le contenu d'un container à un autre. On peut ainsi migrer facilement une installation jupyterhub sur une autre machine.

## Quelques commandes docker utiles :
- Pour fermer l'image, tapez CTRL+C

- Pour réouvrir à nouveau ce container, 
```console
docker start -i jupyterhub
```

- Pour connaître la liste des containers
```console
docker ps -a
```

- Pour connaître la liste des images
```console
docker images
```

- Pour effacer un container (afin de repartir de l'image propre, par exemple de début d'année)
**Attention** les données contenues dans le container seront **détruites** !!!
```console
docker rm CONTAINER_ID
```
- Pour effacer l'image construite (attention !) :
```console
docker rmi jhub_srv
```

- pour lister les volumes :
docker volume ls

- pour avoir des informations sur un volume :
docker volume inspect my-vol
