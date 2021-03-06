#!/bin/bash
#script to install and configure vim with plugins

USER=$(who | cut -d" " -f1)
PASSED_USER=$1
if [ -n "$PASSED_USER" ];then #user passed
	USER=$PASSED_USER
fi
HOME_DIR="/home/$USER"


function install_vim(){
apt-get install -y vim vim-gnome

}

#configure vim
function configure_vim() {
#clone to home_dir
git clone https://github.com/amix/vimrc.git $HOME_DIR/.vim_runtime
#copy to root dir
sudo cp -R $HOME_DIR/.vim_runtime /root/

#script install home_dir
sh $HOME_DIR/.vim_runtime/install_awesome_vimrc.sh

#script install root_dir
sudo sh /root/.vim_runtime/install_awesome_vimrc.sh

#modify my_configs.vim  

#cat > $HOME_DIR/.vim_runtime/my_configs.vim <<EOF
#colorscheme peaksea
#backgroud = dark

#EOF
#configure root settings
#cp -R $HOME_DIR/.vim_runtime/my_configs.vim /root/.vim_runtime/

}

function install_YouCompleteMe() {
#install dependency
apt-get install build-essential cmake python-dev

#YouCompleteMe
git clone https://github.com/Valloric/YouCompleteMe.git $HOME_DIR/.vim_runtime/sources_non_forked/YouCompleteMe

cd $HOME_DIR/.vim_runtime/sources_non_forked/YouCompleteMe/

#submodules
git submodule update --init --recursive

#compilling YCM with semantic support for C-family languages
#./install.py --clang-completer

#compilling YCM without semantic support for C-family languages
./install.py

}

function main(){
install_vim
configure_vim
install_YouCompleteMe

}

main

