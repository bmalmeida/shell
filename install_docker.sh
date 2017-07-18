#!/bin/bash
#steps
#install Docker Engine

################ VARIAVEIS #################
USER_TO_DOCKER=$(who | cut -d" " -f1)
USER_PARAM=$1
############################################

if [ -n "$USER_PARAM" ]; then #passado parametro usuario
    USER_TO_DOCKER=$USER_PARAM
fi

#Must installed curl
function install_dependencies () {
INSTALLED=$(which curl)

if [ ! -n "$INSTALLED" ]; then
    sudo apt-get update && sudo apt-get install curl
fi
}

function install_docker () {
#verify not installed
INSTALLED=$(which docker)
if [ ! -n "$INSTALLED" ]; then #nao instalado
    #get latest Docker packege
    curl -fsSL https://get.docker.com/ | sh

    #Note: If your company is behind a filtering proxy, you may find that the apt-key command fails for the Docker repo during installation. To work around this, add the key directly using the following:
    curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
fi

#start service docker
sudo service docker start
}

function add_user_docker() {
#add a user to docker group
sudo usermod -aG docker $USER_TO_DOCKER

#restart service
sudo service docker restart
}

function add_insecure_registry() {
#adicionar uma linha no arquivo /etc/default/docker contendo --insecure-registry mydomain.com onde
#mydomain.com é o nome do servidor onde se encontra o private registry c/ as imagens
sudo sed -i "1s,^,######### adicionado pelo script de instalação ##########\nDOCKER_OPTS=\"--insecure-registry localhost:5000\"\n\n,g" /etc/default/docker
}

function unistall_complete() {
sudo apt-get purge docker-engine
sudo rm -rf /var/lib/docker
exit
}

function main() {
if [[ ( -n "$USER_PARAM"  && "$USER_PARAM"  == 'unistall' || "$USER_PARAM" == 'remove' ) ]]; then
    echo 'Docker será removido...'
    unistall_complete
fi

install_dependencies
install_docker
add_user_docker
add_insecure_registry
}

main
