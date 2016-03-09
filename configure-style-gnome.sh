#!/bin/bash

DROP_BOX_INSTALLATION='/home/fred/Cloud/Dropbox/Linux/arquivos_de_configuracao/profiles/'

function configure_nautilus(){
    dconf load /org/gnome/desktop/ < $DROP_BOX_INSTALLATION/gnome-desktop-settings 

}

configure_nautilus
