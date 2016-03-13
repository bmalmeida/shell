#!/bin/bash
#
#install and configure zsh with oh-my-zsh
#

function main(){
#check if zsh installed
INSTALLED=`/bin/bash verify_installation.sh zsh`
USER=`ls /home/`

if [ ! $INSTALLED -eq 0 ]; then #not intalled
    sudo apt-get update && sudo apt-get install zsh -y
    INSTALLED=$?
fi

if [ $INSTALLED -eq 0 ]; then #conseguiu instalar
    my_zsh_root
    my_zsh_user
else
    echo 'Erro na instalação!'
fi

}

function my_zsh_root(){
#root
clear
echo "Insert the root password:"
sleep 2
#del folders if exist
sudo rm -rf /root/.zsh*
sudo rm -rf /root/.oh-my-zsh/
su - root sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

}

function my_zsh_user(){
#normal user
#del folders if exist
if [ -d "/home/$USER/.oh-my-zsh/" ]; then
    rm -rf /home/$USER/.zsh*
    rm -rf /home/$USER/.oh-my-zsh/
fi
su - $USER sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

}


main


