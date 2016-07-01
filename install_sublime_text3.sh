#!/bin/bash
HOME_DIR=/home/$(who | cut -d" " -f1)
SUBLIME_DIR=$HOME_DIR/.config/sublime-text-3
INSTALLED_PACKAGE_DIR=$SUBLIME_DIR/Installed\ Packages
PACKAGE_DIR=$SUBLIME_DIR/Packages
#plugins
#Package Control , SideBarEnhancements, BracketHighlighter, SublimeCodeIntel, Theme - Soda, Alignment, Git, jQuery, DocBlockr, All Autocomplete, GitGutter, AutoFileName, Pretty JSON, Terminal, 
#Bootstrap 3 Snippets, 

function install() {
    wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb -O $HOME_DIR/sublime-text3.deb
    sudo dpkg --install $HOME_DIR/sublime-text3.deb 
    #copy config
    if [ -e "./sublime-text3/Preferences.sublime-settings" ]; then
        cp -R ./sublime-text3/Preferences.sublime-settings $PACKAGE_DIR/User
    fi

}

function install_plugins() {
    #packageControll
    if [ ! -d "$INSTALLED_PACKAGE_DIR" ]; then
        mkdir -p "$INSTALLED_PACKAGE_DIR"
    fi
    wget https://packagecontrol.io/Package%20Control.sublime-package -O "$INSTALLED_PACKAGE_DIR/Package Control.sublime-package"

    #Git
    git clone git://github.com/kemayo/sublime-text-2-git.git "$PACKAGE_DIR/Git"
    
    #SideBarEnhancements
    git clone https://github.com/titoBouzout/SideBarEnhancements.git "$PACKAGE_DIR/SideBarEnhancements"

    #BracketHighlighter
    git clone https://github.com/facelessuser/BracketHighlighter.git "$PACKAGE_DIR/BracketHighlighter"

    #SublimeCodeIntel
    git clone git://github.com/SublimeCodeIntel/SublimeCodeIntel.git "$PACKAGE_DIR/SublimeCodeIntel"
    
    #jQuery
    git clone https://github.com/SublimeText/jQuery.git "$PACKAGE_DIR/jQuery"

    #DocBlockr
    git clone https://github.com/spadgos/sublime-jsdocs.git "$PACKAGE_DIR/DocBlockr"

    #SublimeAllAutocomplete
    git clone https://github.com/alienhard/SublimeAllAutocomplete "$PACKAGE_DIR/SublimeAllAutocomplete"

    #GitGutter
    git clone git://github.com/jisaacks/GitGutter.git "$PACKAGE_DIR/GitGutter"
    
    #AutoFileName
    git clone https://github.com/BoundInCode/AutoFileName.git "$PACKAGE_DIR/AutoFileName"

    #terminal
    git clone https://github.com/wbond/sublime_terminal.git "$PACKAGE_DIR/sublime_terminal"

    #pretty json
    git clone https://github.com/dzhibas/SublimePrettyJson.git "$PACKAGE_DIR/SublimePrettyJson"

}

function main() {
    install
    install_plugins

}

main
