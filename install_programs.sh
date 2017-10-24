#!/bin/bash
#declarete array programs
declare -A PROGRAMS

#informacoes sistema
DISTRO_INFO=$(lsb_release -i) #Distributor ID: Ubuntu
DISTRO_ID=${DISTRO_INFO#'Distributor ID:'*} #remove Distributor ID:
DISTRO_ID=$(echo $DISTRO_ID | sed 's/^[ \t]*//') #remove leading spaces
DISTRO_ID=${DISTRO_ID,,}                #to_lower
USER=$(who | cut -d" " -f1)
HOME_DIR=$(pwd)
INSTALL_DIR='/var/programas'
ARCH=$(uname -m)

#programs if true, then will be installed
BASIC_PACKAGES=false
#Cloud/Browsers
CHROME=true
DROP_BOX=false
DROP_BOX_DATE='2015.10.28'
MEGA=false
MEGA_URL='https://mega.nz/linux/MEGAsync/xUbuntu_16.04/amd64/megasync_2.9.1_amd64.deb' #see more https://mega.nz/linux/MEGAsync/
#Multimedia
STREMIO=false
STREMIO_VERSION=3.6.5  #see more http://dl.strem.io/Stremio3.4.5.linux.tar.gz
SPOTIFY=false
#IDE'S
NETBEANS_INSTALL=false
NETBEANS_VERSION=8.0.2 #see more http://www.netbeans.info/downloads/dev.php
PHP_STORM=false
PHP_STORM_VERSION=2017.1.4 #see more https://www.jetbrains.com/phpstorm/download/
EVOLUS_PENCIL_INSTALL=false
EVOLUS_PENCIL_VERSION=2.0.2
MYSQL_WORKBENCH=false
DATA_STUDIO=false
#others with script
GIT=false
VIM=false
DOCKER=false
ZSH=false
JAVA=false
JAVA_VERSION=8 #7,8,9
CAIXA_MODULE=false
SUBLIME_TEXT=false
MOUNT_PARTITION=false
DEVICE=desktop
CREATE_LINKS=false
THEME_FLATABULOUS=false
THEME_BREEZY=true
PAPIROS_ICONS=true
ULTRA_FLAT_ICONS=false
SLACK=false
SLACK_VERSION=2.6.3

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
        sudo apt-get install wget curl vlc arj p7zip p7zip-full alacarte htop meld gpicview gnome-tweak-tool synergy gdebi unity-tweak-tool ambiance-blackout-flat-colors papirus-icon-theme -y
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
        if [ $? -eq 0 ]; then
            PROGRAMS['chrome']=true
        else
            PROGRAMS['chrome']=false;
        fi

        #del files
        rm -rf $INSTALL_DIR/google-chrome* > /dev/null 2>&1
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
        if [ $? -eq 0 ]; then
            PROGRAMS['dropbox']=true
        else
            PROGRAMS['dropbox']=false;
        fi
        #del files
        rm -rf $INSTALL_DIR/dropbox-*
    fi

    #instalacao mega-cz
    if [ $MEGA == true ]; then

        apt-get --purge remove mega* -y > /dev/null 2>&1

        #download
        wget $MEGA_URL -O $INSTALL_DIR/mega.deb

        cd $INSTALL_DIR

        gdebi mega.deb --n
        if [ $? -eq 0 ]; then
            PROGRAMS['mega']=true
        else
            PROGRAMS['mega']=false;
        fi
        rm -rf $INSTALL_DIR/mega-*
    fi

    #instalacao stremio
    if [ $STREMIO == true ]; then
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
        if [ $? -eq 0 ]; then
            PROGRAMS['stremio']=true
        else
            PROGRAMS['stremio']=false;
        fi
        rm -rf $INSTALL_DIR/stremio.tar.gz
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
        if [ $? -eq 0 ]; then
            PROGRAMS['spotify']=true
        else
            PROGRAMS['spotify']=false;
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
        if [ $? -eq 0 ]; then
            PROGRAMS['phpstorm']=true
        else
            PROGRAMS['phpstorm']=false;
        fi
        rm -rf $INSTALL_DIR/phpstorm.tar.gz
    fi

    #instalacao mysqlworkbench
    if [ $MYSQL_WORKBENCH == true ]; then
#         if [ $ARCH != 'x86_64' ]; then #sistema 32bit
#             ARCH2=i386
#         else
#             ARCH2=amd64
#         fi
#
#         #verifica nome distro
#         if [[ $DISTRO_ID == ubuntu || $DISTRO_ID == debian ]]; then
#             DISTRO_ID2=1ubu1504
#         else
#             DISTRO_ID2=other
#         fi
#
#         if [ $DISTRO_ID2 != other ]; then
#
#             #wget http://ftp.kaist.ac.kr/mysql/Downloads/MySQLGUITools/mysql-workbench-community-$MYSQL_WORKBENCH_VERSION-$DISTRO_ID2-$ARCH2.deb -O $INSTALL_DIR/mysql-workbench.deb
#
#             #dependencia necessaria libjpeg8
#             #wget http://ftp.us.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d1-2_$ARCH2.deb -O $INSTALL_DIR/libjpeg8.deb
#
#             sudo apt-get --purge remove mysql* -y > /dev/null 2>&1
#
#             #instalar dependencia
#             cd $INSTALL_DIR
#             sudo gdebi libjpeg8.deb  --n  #> /dev/null 2>&1 #auto accept
#             if [ $? -eq 0 ]; then
#                 PROGRAMS['mysql-libjpeg8']=true
#             else
#                 PROGRAMS['mysql-libjpeg8']=false;
#             fi
#
#             #dependencia
#             sudo apt-get install -y libatkmm-1.6*
#             sudo gdebi mysql-workbench.deb --n # > /dev/null 2>&1 #auto accept
#             if [ $? -eq 0 ]; then
#                 PROGRAMS['mysql-workbench']=true
#             else
#                 PROGRAMS['mysql-workbench']=false;
#             fi
#
#             #rm -rf mysql-workbench*
#             #rm -rf libjpeg8*
#         else
#             echo 'Other System.. Please do the download manual
#             on: http://dev.mysql.com/downloads/workbench/'
#         fi
            sudo apt-get install -y mysql-workbench
            if [ $? -eq 0 ]; then
                PROGRAMS['phpstorm']=true
            else
                PROGRAMS['phpstorm']=false;
            fi
    fi

    #git
    if [ $GIT == true ]; then
	cd $HOME_DIR
        sudo ./install_and_configure_git.sh $USER
        if [ $? -eq 0 ]; then
            PROGRAMS['git']=true
        else
            PROGRAMS['git']=false;
        fi
    fi

    #vim
    if [ $VIM == true ]; then
	cd $HOME_DIR
        sudo ./install_vim.sh $USER
	if [ $? -eq 0 ]; then
            PROGRAMS['vim']=true
        else
            PROGRAMS['vim']=false;
        fi
    fi

    #docker
    if [ $DOCKER == true ]; then
	cd $HOME_DIR
        sudo ./install_docker.sh $USER
        if [ $? -eq 0 ]; then
            PROGRAMS['docker']=true
        else
            PROGRAMS['docker']=false;
        fi
    fi

    #zsh
    if [ $ZSH == true ]; then
	cd $HOME_DIR
        sudo ./install_zsh_with_oh_my_sh.sh
	if [ $? -eq 0 ]; then
            PROGRAMS['zsh']=true
        else
            PROGRAMS['zsh']=false;
        fi
    fi


    #java
    if [ $JAVA == true ]; then
	cd $HOME_DIR
        sudo ./install_java.sh $JAVA_VERSION
        if [ $? -eq 0 ]; then
            PROGRAMS['java']=true
        else
            PROGRAMS['java']=false;
        fi
    fi

    #sublime-text
    if [ $SUBLIME_TEXT == true ]; then
	cd $HOME_DIR
        sudo ./install_sublime_text3.sh
        if [ $? -eq 0 ]; then
            PROGRAMS['sublime-text']=true
        else
            PROGRAMS['sublime-text']=false;
        fi
    fi

    #caixa module
    if [ $CAIXA_MODULE == true ]; then
	cd $HOME_DIR
        sudo ./install_modulo_seg_caixa.sh
        if [ $? -eq 0 ]; then
            PROGRAMS['caixa-module']=true
        else
            PROGRAMS['caixa-module']=false;
        fi
    fi

    #mount-partition
    if [ $MOUNT_PARTITION == true ]; then
	cd $HOME_DIR
        sudo ./mount_partition.sh desktop
        if [ $? -eq 0 ]; then
            PROGRAMS['mount-partition']=true
        else
            PROGRAMS['mount-partition']=false;
        fi
    fi

    #create links
    if [ $CREATE_LINKS == true ]; then
        if [ $DEVICE == desktop ]; then
            ln -s /media/DADOS/Pictures /home/$USER/Pictures
            ln -s /media/DADOS/Documentos home/$USER/Documents
            ln -s /media/DADOS/Cloud /home/$USER/Cloud
            ln -s /media/DADOS/Downloads /home/$USER/Downloads
            ln -s /media/DADOS/Filmes /home/$USER/Videos
            ln -s /media/DADOS/git /home/$USER/git
        fi
        if [ $? -eq 0 ]; then
            PROGRAMS['create-links']=true
        else
            PROGRAMS['create-links']=false;
        fi
    fi

    #datastudio
    if [ $DATA_STUDIO == true ]; then
        if [ -f "/media/DADOS/Programas/datastudio6.5.tar.gz" ]; then #file exist
            tar -xzvf /media/DADOS/Programas/datastudio6.5.tar.gz -C $INSTALL_DIR/
        fi
        if [ $? -eq 0 ]; then
            PROGRAMS['data-studio']=true
        else
            PROGRAMS['data-studio']=false;
        fi
    fi

    #theme flatabulous
    if [ $THEME_FLATABULOUS == true ];then
        wget https://github.com/anmoljagetia/Flatabulous/archive/master.zip -O $INSTALL_DIR/flatabulous.zip
        cd $INSTALL_DIR
        if [ ! -d "/home/$USER/.themes" ]; then
            mkdir /home/$USER/.themes
        fi
        unzip $INSTALL_DIR/flatabulous.zip -d /home/$USER/.themes/

        if [ $? -eq 0 ]; then
            PROGRAMS['flatabulous-theme']=true
        else
            PROGRAMS['flatabulous-theme']=false;
        fi
    fi

    #theme breezy
    if [ $THEME_BREEZY == true ];then
        wget https://github.com/nivekxyz/breezy-gtk/archive/master.zip -O $INSTALL_DIR/breezy.zip
        cd $INSTALL_DIR
        if [ ! -d "/home/$USER/.themes" ]; then
            mkdir /home/$USER/.themes
        fi
        unzip $INSTALL_DIR/breezy.zip -d /home/$USER/.themes/

        if [ $? -eq 0 ]; then
            PROGRAMS['breezy-theme']=true
        else
            PROGRAMS['breezy-theme']=false;
        fi
    fi

    #ultra-flat icons
    if [ $ULTRA_FLAT_ICONS == true ];then
        sudo add-apt-repository ppa:noobslab/icons -y
        sudo apt-get update
        sudo apt-get install -y ultra-flat-icons ultra-flat-icons-green ultra-flat-icons-orange
        if [ $? -eq 0 ]; then
            PROGRAMS['ultra-flat-icons']=true
        else
            PROGRAMS['ultra-flat-icons']=false;
        fi
    fi

    #papiro icons
    if [ $PAPIRO_ICONS == true ];then
	sudo su
	wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-root.sh | sh
        if [ $? -eq 0 ]; then
            PROGRAMS['papiro-icons']=true
        else
            PROGRAMS['papiro-icons']=false;
        fi
    fi

    #slack
    if [ $SLACK == true ];then
        wget https://downloads.slack-edge.com/linux_releases/slack-desktop-$SLACK_VERSION-amd64.deb -O $INSTALL_DIR/slack.deb
        cd $INSTALL_DIR
        gdebi slack.deb --n

        if [ $? -eq 0 ]; then
            PROGRAMS['slack']=true
        else
            PROGRAMS['slack']=false;
        fi
    fi
}

function verify_installation() {
    clear
    for index in ${!PROGRAMS[*]}; do
        echo "Program: $index instalado: ${PROGRAMS[$index]}"
    done

}

function main() {
    verify_dir
    install_programs
    verify_installation
}

main
