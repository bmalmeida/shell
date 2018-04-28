#!/bin/bash
HOME_DIR=/home/$(who | cut -d" " -f1)
SUBLIME_DIR=$HOME_DIR/.config/sublime-text-3
INSTALLED_PACKAGE_DIR=$SUBLIME_DIR/Installed\ Packages
PACKAGE_DIR=$SUBLIME_DIR/Packages
#plugins
#Package Control , SideBarEnhancements, BracketHighlighter, SublimeCodeIntel, Theme - Soda, Alignment, Git, jQuery, DocBlockr, All Autocomplete, GitGutter, AutoFileName, Pretty JSON, Terminal,
#Bootstrap 3 Snippets,

function install() {
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    
    sudo apt-get install apt-transport-https

    
    #stable
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    
    sudo dpkg --install $HOME_DIR/sublime-text3.deb

    sudo apt-get update
    sudo apt-get install sublime-text

    #User dir not exists
    if [ ! -d "$PACKAGE_DIR/User" ]; then
	mkdir $PACKAGE_DIR/User
    fi

    #copy config
    if [ -e "./sublime-text3/Preferences.sublime-settings" ]; then
        cp -R ./sublime-text3/Preferences.sublime-settings $PACKAGE_DIR/User
    fi

    if [ -e "./sublime-text3/Default.sublime-mousemap" ]; then
        cp -R ./sublime-text3/Default.sublime-mousemap $PACKAGE_DIR/User
    fi

    chmod 777 -R ${PACKAGE_DIR}/User
    sudo chown ${USER}:${USER} -R $PACKAGE_DIR/User
    sudo chown ${USER}:${USER} -R ${SUBLIME_DIR}
}

function install_plugins() {
    #packageControll
    if [ ! -d "$INSTALLED_PACKAGE_DIR" ]; then
        mkdir -p "$INSTALLED_PACKAGE_DIR"
    fi
    wget https://packagecontrol.io/Package%20Control.sublime-package -O "$INSTALLED_PACKAGE_DIR/Package Control.sublime-package"
    wget https://packagecontrol.io/Package%20Control.sublime-package -O "$INSTALLED_PACKAGE_DIR/Package Control.sublime-package"

    #Git
    if [ !  -d "$PACKAGE_DIR/Git" ]; then
	git clone https://github.com/kemayo/sublime-text-git.git "$PACKAGE_DIR/Git"
        #git clone git://github.com/kemayo/sublime-text-2-git.git "$PACKAGE_DIR/Git"
    fi

    #SideBarEnhancements
    if [ !  -d "$PACKAGE_DIR/SideBarEnhancements" ]; then
        git clone https://github.com/titoBouzout/SideBarEnhancements.git "$PACKAGE_DIR/SideBarEnhancements"
    fi

    #BracketHighlighter
    if [ !  -d "$PACKAGE_DIR/BracketHighlighter" ]; then
        git clone https://github.com/facelessuser/BracketHighlighter.git "$PACKAGE_DIR/BracketHighlighter"
    fi

    #SublimeCodeIntel
     if [ !  -d "$PACKAGE_DIR/SublimeCodeIntel" ]; then
        git clone git://github.com/SublimeCodeIntel/SublimeCodeIntel.git "$PACKAGE_DIR/SublimeCodeIntel"
    fi


    #jQuery
    if [ !  -d "$PACKAGE_DIR/jQuery" ]; then
         git clone https://github.com/SublimeText/jQuery.git "$PACKAGE_DIR/jQuery"
    fi

    #DocBlockr
     if [ !  -d "$PACKAGE_DIR/DocBlockr" ]; then
         git clone https://github.com/spadgos/sublime-jsdocs.git "$PACKAGE_DIR/DocBlockr"
    fi

    #SublimeAllAutocomplete
     if [ !  -d "$PACKAGE_DIR/SublimeAllAutocomplete" ]; then
         git clone https://github.com/alienhard/SublimeAllAutocomplete "$PACKAGE_DIR/SublimeAllAutocomplete"
    fi

    #GitGutter
     if [ !  -d "$PACKAGE_DIR/GitGutter" ]; then
         git clone git://github.com/jisaacks/GitGutter.git "$PACKAGE_DIR/GitGutter"
    fi

    #AutoFileName
     if [ !  -d "$PACKAGE_DIR/AutoFileName" ]; then
         git clone https://github.com/BoundInCode/AutoFileName.git "$PACKAGE_DIR/AutoFileName"
    fi

    #terminal
         if [ !  -d "$PACKAGE_DIR/sublime_terminal" ]; then
         git clone https://github.com/wbond/sublime_terminal.git "$PACKAGE_DIR/sublime_terminal"
    fi

    #pretty json
    if [ !  -d "$PACKAGE_DIR/SublimePrettyJson" ]; then
         git clone https://github.com/dzhibas/SublimePrettyJson.git "$PACKAGE_DIR/SublimePrettyJson"
    fi

    #CodeFormater
    if [ ! -d "$PACKAGE_DIR/CodeFormatter" ]; then
         git clone https://github.com/akalongman/sublimetext-codeformatter.git "$PACKAGE_DIR/CodeFormatter"
    fi

    #
    # THEMES
    
    #Soda
    if [ ! -d "$PACKAGE_DIR/Soda-theme" ]; then
		git clone https://github.com/buymeasoda/soda-theme/ "$PACKAGE_DIR/Soda-theme"
    fi

    #Material
    if [ ! -d "$PACKAGE_DIR/Material-theme" ]; then
		git clone https://github.com/equinusocio/material-theme.git "$PACKAGE_DIR/Material-theme"
    fi

    
}

function main() {
    install
    install_plugins

}

main
