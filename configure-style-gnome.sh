#!/bin/bash

DROP_BOX_INSTALLATION='/home/fred/Cloud/Dropbox/Linux/arquivos_de_configuracao/profiles/'

function configure_nautilus(){
if [ -e $DROP_BOX_INSTALLATION/terminal-settings-12-03-2016_bkp_pc ]; then
    dconf load /org/gnome/desktop/ < $DROP_BOX_INSTALLATION/gnome-desktop-settings 
fi
}

function configure_terminal(){
if [ -e $DROP_BOX_INSTALLATION/terminal-settings-12-03-2016_bkp_pc ]; then
    dconf load /org/gnome/terminal/ < $DROP_BOX_INSTALLATION/terminal-settings-12-03-2016_bkp_pc
fi
}

function main(){
configure_nautilus

configure_terminal
}

main
