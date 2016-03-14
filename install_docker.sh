#!/bin/bash
#steps
#install Docker Engine

################ VARIAVEIS #################
USER_TO_DOCKER='fred' #passar como parametro p/ script
USER_PARAM=$1
############################################


if [ -n "$USER_PARAM" ]; then #passado parametro usuario
    USER_TO_DOCKER=$USER_PARAM
fi

#Must installed curl
function install_dependencies(){
INSTALLED=`which curl`

if [ ! -n "$INSTALLED" ]; then
    sudo apt-get update && sudo apt-get install curl
fi
}

function install_docker () {
#verify not installed
INSTALLED=`which docker`
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

function main() {
install_dependencies
install_docker
add_user_docker
}   

main
