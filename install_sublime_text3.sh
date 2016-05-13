#!/bin/bash
HOME_DIR=$(ls /home)
#plugins
#Package Control , SideBarEnhancements, BracketHighlighter, SublimeCodeIntel, Theme - Soda, Alignment, Git, jQuery, DocBlockr, All Autocomplete, GitGutter, AutoFileName, Pretty JSON, Terminal, 
#Bootstrap 3 Snippets, 
function install() {
    wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb -O /home/$HOME_DIR/sublime-text3.deb
    sudo dpkg --insatll $HOME_DIR/sublime-text3.deb -y
}


install

