#!/bin/bash
#
#install and configure zsh with oh-my-zsh
#

function main(){
    #check if zsh installed
    INSTALLED=`/bin/bash verify_installation.sh zsh`
    USER=`ls /home/`
    
    if [ ! $INSTALLED -eq 0 ]; then #not intalled
        apt-get update && apt-get install zsh -y
    fi
    
    my_zsh
}

function my_zsh(){
    #root
    su - root sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

    #normal user
    su - $USER sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

main


