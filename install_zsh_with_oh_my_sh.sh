#!/bin/bash

#install and configure zsh with oh-my-sh

#apt-get install zsh

#verify_installation(){
#SUCCESS= `which $1`
#    if ( $SUCCESS -eq 0 ); then
#        echo 'instalado'
#    else
#        echo 'nao instalado'
#    fi
#}

#check if program installed
$INSTALLED=`(/bin/bash verify_installation.sh 'zsh')`

if [ ! "$INSTALLED" -eq 0 ]; then #not intalled
    echo 'not installed'
else
    echo 'instalado'
fi

