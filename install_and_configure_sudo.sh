#!/bin/bash
#instala sudo p/ ser utilizado comando sudo

#usuario p/ adicionar ao grupo sudo
USER_PARAM=$1 #passar como parametro o usuario p/ ser criado
USER_TO_SUDO='fred' #deve ser um usuário válido no sistema

function verify_param() {
if [ -n "$USER_PARAM" ]; then #passado parametro usuario
    USER_TO_SUDO=$USER_PARAM
fi
}


function install_sudo() {
INSTALLED=`which sudo`
if [ ! -n "$INSTALLED" ]; then 
    apt-get update && apt-get install sudo > /dev/null 2>&1
fi
}

function add_user_sudo() {
gpasswd -a $USER_TO_SUDO sudo  #adiciona o $USER_TO_SUDO ao grupo sudo
}

function add_user() {
adduser $USER_TO_SUDO
}

function main() {
verify_param
add_user
install_sudo
add_user_sudo
}

main
