#!/bin/bash 
#informacoes sistema
DISTRO_INFO=$(lsb_release -i) #Distributor ID: Ubuntu
DISTRO_ID=${DISTRO_INFO#'Distributor ID:'*} #remove Distributor ID:
DISTRO_ID=$(echo $DISTRO_ID | sed 's/^[ \t]*//') #remove leading spaces
DISTRO_ID=${DISTRO_ID,,}                #to_lower


MSG_SUCCESS=':: Instalado com sucesso :: '
MSG_ERROR=':: Erro na instalação :: '

INSTALL_DIR='/usr/local/programas'
ARCH=$(uname -m)

#programs if true, then will be installed
BASIC_PACKAGES=false
CHROME=false
DROP_BOX=false
DROP_BOX_DATE='2015.10.28'
MEGA=false
MEGA_URL='https://mega.nz/linux/MEGAsync/xUbuntu_16.04/amd64/megasync_2.9.1_amd64.deb' #see more https://mega.nz/linux/MEGAsync/
STREMIO=false
STREMIO_VERSION=3.5.7  #see more http://dl.strem.io/Stremio3.4.5.linux.tar.gz
SPOTIFY=true
#IDE'S
NETBEANS_INSTALL=false
NETBEANS_VERSION=8.0.2 #see more http://www.netbeans.info/downloads/dev.php
PHP_STORM=false
PHP_STORM_VERSION=9.0.2 #see more https://www.jetbrains.com/phpstorm/download/
EVOLUS_PENCIL_INSTALL=false
EVOLUS_PENCIL_VERSION=2.0.2


#################################################

function verify_dir() {
    if [ ! -d $INSTALL_DIR ]; then
        mkdir -p $INSTALL_DIR
        sudo chmod 777 -R $INSTALL_DIR
    fi
}

function install_programs() {
    #basic
    if [ $BASIC_PACKAGES == true ]; then
        sudo apt-get install wget curl vlc arj p7zip p7zip-full alacarte htop meld gpicview gnome-tweak-tool synergy gdebi unity-tweak-tool -y
    fi

    #google chrome
    if [ $CHROME == true ]; then
        if [ $ARCH != 'x86_64' ]; then #sistema 32bit
            ARCH2=i386
        else
            ARCH2=amd64
        fi

        #baixar chrome ultima versao
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH2.deb -O $INSTALL_DIR/google-chrome.deb
        
        #remove versao anterior
        dpkg -r google-chrome-stable > /dev/null 2>&1

        cd $INSTALL_DIR 
        gdebi google-chrome.deb --n 
        INSTALL_SUCCESS=$?
        
        #del files
        rm -rf $INSTALL_DIR/google-chrome* > /dev/null 2>&1

        #verifica se  foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS Google Chrome"
        else
            echo "$MSG_ERROR Google Chrome"
        fi
    fi
       
    #instalacao drop-box
    if [ $DROP_BOX == true ]; then
        if [ $ARCH != 'x86_64' ]; then #sistema 32bit
            ARCH2=i386
        else
            ARCH2=amd64
        fi  
        echo /$DISTRO_ID
        #download
        wget https://www.dropbox.com/download?dl=packages/$DISTRO_ID/dropbox_$DROP_BOX_DATE"_"$ARCH2.deb -O $INSTALL_DIR/dropbox.deb

        #unistall old
        apt-get --purge remove dropbox* -y > /dev/null 2>&1

        cd $INSTALL_DIR
        gdebi dropbox.deb --n
        INSTALL_SUCCESS=$?

        #del files
        rm -rf $INSTALL_DIR/dropbox-*

        #verifica se foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS Dropbox"
        else
            echo "$MSG_ERROR Dropbox"
        fi
    fi

    #instalacao mega-cz
    if [ $MEGA == true ]; then

        apt-get --purge remove mega* -y > /dev/null 2>&1

        #download
        wget $MEGA_URL -O $INSTALL_DIR/mega.deb
        
        cd $INSTALL_DIR
        
        gdebi mega.deb --n
        INSTALL_SUCCESS=$?

        rm -rf $INSTALL_DIR/mega-*

        #verifica se foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS Mega"
        else
            echo "$MSG_ERROR Mega"
        fi
    fi

    #instalacao stremio
    if [ $STREMIO == true ]; then
        echo 'stremio'
        exit
        wget http://dl.strem.io/Stremio$STREMIO_VERSION.linux.tar.gz -O $INSTALL_DIR/stremio.tar.gz
        wget http://www.strem.io/3.0/stremio-white-small.png -O $INSTALL_DIR/stremio.png

        sudo rm -rf /$INSTALL_DIR/stremio
        sudo rm -rf /usr/bin/stremio
        sudo rm -ff /usr/bin/Stremio-runtime

        cd $INSTALL_DIR

        mkdir stremio

        tar -xvzf stremio.tar.gz -C  $INSTALL_DIR/stremio/

        mv $INSTALL_DIR/stremio.png $INSTALL_DIR/stremio/
        sudo chmod 777 -R $INSTALL_DIR/stremio/

        sudo chmod +x $INSTALL_DIR/stremio/Stremio.sh

        #cria links
        sudo ln -s $INSTALL_DIR/stremio/Stremio.sh /usr/bin/stremio
        sudo ln -s $INSTALL_DIR/stremio/Stremio-runtime /usr/bin/Stremio-runtime
        INSTALL_SUCCESS=$?

        rm -rf $INSTALL_DIR/stremio.tar.gz

        #verifica se foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS Stremio"
        else
            echo "$MSG_ERROR Stremio"
        fi
    fi

    #instalacao spotify
    if [ $SPOTIFY == true ]; then
        if [ $ARCH != 'x86_64' ]; then #sistema 32bit
            ARCH2=i386
        else
            ARCH2=amd64
        fi  

        #download 
        #wget http://ftp.us.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u3_$ARCH2.deb -O $INSTALL_DIR/spotify.deb
        #dpkg -i libcrypt11_1.5.0.deb #-y é preciso?????

        #add key    
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

        #add repository 
        sudo echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list

        #update system
        apt-get update  -y

        apt-get install spotify-client -y 
        INSTALL_SUCCESS=$?

        #verifica se foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS Spotify"
        else
            echo "$MSG_ERROR Spotify"
        fi
    fi

    #instalacao phpStorm
    if [ $PHP_STORM == true ]; then
        wget http://download.jetbrains.com/webide/PhpStorm-$PHP_STORM_VERSION.tar.gz -O $INSTALL_DIR/phpstorm.tar.gz

        sudo rm -rf /usr/bin/phpstorm

        sudo rm -rf $INSTALL_DIR/phpStorm
        mkdir $INSTALL_DIR/phpStorm
        chmod 777 -R $INSTALL_DIR/phpStorm         

        cd $INSTALL_DIR
        tar xvzf phpstorm.tar.gz -C $INSTALL_DIR/phpStorm/

        chmod +x $INSTALL_DIR/phpStorm/*/bin/phpstorm.sh
        sudo ln -s $INSTALL_DIR/phpStorm/*/bin/phpstorm.sh /usr/bin/phpstorm
        INSTALL_SUCCESS=$?

        rm -rf $INSTALL_DIR/phpstorm.tar.gz

        #verifica se foi instalado com sucesso
        if [ $INSTALL_SUCCESS -eq 0 ]; then
            echo "$MSG_SUCCESS phpStorm"
        else
            echo "$MSG_ERROR phpStorm"
        fi
    fi



}

function main() {
    verify_dir
    install_programs
}

main
