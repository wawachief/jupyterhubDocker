#!/bin/bash

# Creation automatique de comptes
# entree : fichier CSV separe par ;
# login;passwd ou alors login;passwd;1 pour les profs


FICH=$1
ADMIN="adminjh"
echo $FICH
for i in `cat $FICH`
do
USER=`echo $i | awk -F";" '{ print $1 }'`
PASS=`echo $i | awk -F";" '{ print $2 }'`
PROF=`echo $i | awk -F";" '{ print $3 }'`

/usr/sbin/useradd $USER -s /bin/bash
echo "$USER:$PASS" | /usr/sbin/chpasswd
mkdir /home/$USER
chown $USER /home/$USER

if [ -n "$PROF" ]; then
        # Deploiement de la conf nbgrader
        mkdir -p /home/$USER/.jupyter
        cat /home/$ADMIN/.jupyter/nbgrader_config.py |sed -e "s/$ADMIN/$USER/g" > /home/$USER/.jupyter/nbgrader_config.py
        mkdir /home/$USER/source
        cp /home/$ADMIN/source/header.ipynb /home/$USER/source
        cp -r /home/$ADMIN/exemples /home/$USER
        mv /home/$USER/exemples/nbgrader/* /home/$USER/source
        rm -r /home/$USER/exemples/nbgrader
        # Activation de nbgrader pour le prof $USER
        chmod -R 700 /home/$USER
        chown -R $USER /home/$USER
        su $USER -c "/opt/conda/bin/jupyter nbextension enable --user formgrader/main --section=tree"
        su $USER -c "/opt/conda/bin/jupyter serverextension enable --user nbgrader.server_extensions.formgrader"
fi


# lien feedback
ln -s /srv/feedback /home/$USER/feedback

done
