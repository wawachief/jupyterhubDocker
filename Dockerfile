FROM jupyterhub/jupyterhub

LABEL maintainer="Olivier Lecluse <olivier.lecluse@free.fr>"

USER root

ARG JH_ADMIN=adminjh 
ARG JH_PWD=wawa 

RUN apt-get update && apt-get install -yq --no-install-recommends \
        python3-pip \
        git \
        g++ \
        gcc \
        libc6-dev \
        libffi-dev \
        libgmp-dev \
        make \
        xz-utils \
        zlib1g-dev \
        gnupg \
        vim \
        texlive-xetex \
        pandoc \
        sudo \
        netbase \
 && rm -rf /var/lib/apt/lists/* 

RUN pip install jupyter

RUN useradd $JH_ADMIN --create-home --shell /bin/bash

# Install nbgrader
RUN pip install SQLAlchemy==1.2.19 nbgrader && \
    jupyter nbextension install --sys-prefix --py nbgrader --overwrite && \
    jupyter nbextension enable --sys-prefix --py nbgrader && \
    jupyter serverextension enable --sys-prefix --py nbgrader

COPY nbgrader_config.py /home/$JH_ADMIN/.jupyter/nbgrader_config.py
COPY jupyterhub_config.py /srv/jupyterhub/

RUN mkdir -p /home/$JH_ADMIN/.jupyter && \
    mkdir /home/$JH_ADMIN/source
COPY header.ipynb /home/$JH_ADMIN/source
RUN chown -R $JH_ADMIN /home/$JH_ADMIN && \
    chmod 700 /home/$JH_ADMIN

RUN mkdir -p /srv/nbgrader/exchange && \
    chmod ugo+rw /srv/nbgrader/exchange

RUN echo "$JH_ADMIN:$JH_PWD" | chpasswd

# droits sudo root pour JH_ADMIN !!
RUN groupadd admin && \
    usermod -a -G admin $JH_ADMIN

# Paquets pip

RUN pip install --upgrade jupyterlab-server
RUN pip install mobilechelonian \
    nbconvert \ 
    pandas \ 
    matplotlib  \ 
    folium  \ 
    geopy \
    ipython-sql \ 
    metakernel \ 
    pillow \
    nbautoeval

# Creation des exemples

COPY --chown=1000 exemples /home/$JH_ADMIN/exemples

# Creation des comptes
COPY comptes.csv /root
COPY import_comptes.sh /usr/bin
RUN chmod 755 /usr/bin/import_comptes.sh
RUN /usr/bin/import_comptes.sh /root/comptes.csv

EXPOSE 8000

