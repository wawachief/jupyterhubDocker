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
[https://www.digitalocean.com/community/tutorials/comment-installer-et-utiliser-docker-sur-ubuntu-18-04-fr]
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
