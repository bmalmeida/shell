#!/bin/bash

######################## VARIAVEIS ####################################
#informacoes sistema
DISTRO_INFO=`lsb_release -i`				#Distributor ID: Ubuntu
DISTRO_ID=${DISTRO_INFO#'Distributor ID:'*}		#remove Distributor ID:
DISTRO_ID=${DISTRO_ID//'	'}			#remove leading spaces
DISTRO_ID=${DISTRO_ID,,}				#to_lower

DISTRO_INFO=`lsb_release -r`				#Release: 14.04
DISTRO_RELEASE=${DISTRO_INFO#'Release:'*}		#remove Release: 
DISTRO_RELEASE=${DISTRO_RELEASE//'	'}		#remove leading spaces

DISTRO_INFO=`lsb_release -c`				#Codename: 
DISTRO_NAME=${DISTRO_INFO#'Codename:'*}			#remove Codename: 
DISTRO_NAME=${DISTRO_NAME//'	'}			#remove leading spaces

ARCH=`uname -m` #arquitetura do sistema 		#x86_64
PATH_TO_INSTALL='/usr/local/programas'
########## variaveis de sistema ######################################

LO_VERSION='5.0.4'	 #libreOffice version
LO_INSTALL=true  	#se é p/ instalar libreOffice
CHROME_INSTALL=true
FIREFOX_INSTALL=true
FIREFOX_VERSION='41.0.2'
VIRTUAL_BOX_INSTALL=true
DROP_BOX_INSTALL=true
DROP_BOX_DATE='2015.10.28' #data ou versao "2.10.0" p/ montar o link p/ download entrar em: https://linux.dropbox.com/packages/$DISTRO_NAME e ver qual a última data.. [tentar automatizar]
MEGA_INSTALL=true
#MEGA_VERSION=2.3.1 # foi removido do link a versao.. somente https://mega.nz/linux/MEGAsync/Debian_8.0/amd64/megasync-Debian_8.0_amd64.deb
MYSQL_WORKBENCH_INSTALL=true
MYSQL_WORKBENCH_VERSION=6.3.5
VAGRANT_INSTALL=true
VAGRANT_VERSION=1.7.4
SPOFITY_INSTALL=true

#APLICATIVOS EXTRAS
STREMIO_INSTALL=true #app to stream of video like NETFLIX 
STREMIO_VERSION=3.4.5  #see more http://dl.strem.io/Stremio3.4.5.linux.tar.gz


DEL_FILES_AFTER_INSTALL=true	#verifica se é para deletar arquivos baixados após instalação default false

#IDE'S
NETBEANS_INSTALL=false
NETBEANS_VERSION=8.0.2 #see more http://www.netbeans.info/downloads/dev.php
PHP_STORM_INSTALL=true
PHP_STORM_VERSION=9.0.2 #see more https://www.jetbrains.com/phpstorm/download/
EVOLUS_PENCIL_INSTALL=true
EVOLUS_PENCIL_VERSION=2.0.2

#################### MSG'S SUCCESS.. ERROR.. #########################
MSG_UPDATING_SYSTEM= ':: Atualizando repositórios... '
MSG_UNISTALL=':: Removendo versão anterior... '
MSG_DELETE=':: Removendo arquivos pós-instalação... '
MSG_DOWNLOADING=':: Downloading... '
MSG_INSTALLING=':: Instalando... '
MSG_SUCCESS=':: Instalado com sucesso :: '
MSG_ERROR=':: Erro na instalação :: '

# [[[ obs:: padronizar mensagens de success and errorr]]]

#######################################################################

#comentar linha em /etc/apt/sources.list referente a atualização por cd
#sed -i "s,deb cdrom:,#deb cdrom:,g"  /etc/apt/sources.list
#echo 'Updating system...'
#sleep 2
#apt-get update

#tem em repositório

apt-get install curl vlc arj p7zip p7zip-full alacart htop meld gPicView vim vim-gnome -y

#install syntax colorized to vim
git clone https://github.com/fredericomartini/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh


clear

#instalacao libreOffice
if [ $LO_INSTALL == true ]; then
	echo "$MSG_DOWNLOADING LibreOffice"
	sleep 2
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=x86	
	else
		ARCH2=x86-64	 #link p/ download é com - ao invés de _
	fi
		#baixar libreoffice ultima versao
		wget --output-document=libreOffice-$LO_VERSION.tar.gz http://download.documentfoundation.org/libreoffice/stable/$LO_VERSION/deb/$ARCH/LibreOffice_"$LO_VERSION"_Linux_"$ARCH2"_deb.tar.gz
		#language-pack
		wget --output-document=libreOffice-$LO_VERSION-Language-pt-br.tar.gz http://download.documentfoundation.org/libreoffice/stable/$LO_VERSION/deb/$ARCH/LibreOffice_"$LO_VERSION"_Linux_"$ARCH2"_deb_langpack_pt-BR.tar.gz

	echo "$MSG_UNISTALL LibreOffice" #removendo versão anterior
	sleep 2
	apt-get --purge remove libreoffice* -y	> /dev/null 2>&1

	#instalacao libreOffice
	tar xvzf libreOffice-$LO_VERSION.tar.gz -C /tmp/ > /dev/null 2>&1

	echo "$MSG_INSTALLING LibreOffice" #installing
	sleep 1

	dpkg -i /tmp/Libre*/DEBS/*.deb > /dev/null 2>&1
	LO_INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE LibreOffice" #removendo arquivos pós-instalação
		rm -rf /tmp/Libre* > /dev/null 2>&1
		rm -rf libreOffice-$LO_VERSION.tar.gz > /dev/null 2>&1
		sleep 1
	fi
	#instalacao language-pack
	echo "$MSG_INSTALLING LibreOffice Language-pack" #installing
	sleep 2
	tar xvzf libreOffice-$LO_VERSION-Language-pt-br.tar.gz -C /tmp/ > /dev/null 2>&1
	dpkg -i /tmp/Libre*/DEBS/*.deb > /dev/null 2>&1
	LO_INSTALL_LANG_PACK_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE LibreOffice Language-pack" #removendo arquivos pós-instalação
		rm -rf libreOffice-$LO_VERSION-Language-pt-br.tar.gz > /dev/null 2>&1
		sleep 1
	fi

	#verifica se libreOffice e lang-pack foi instalado com sucesso
	if [ $LO_INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS LibreOffice $LO_VERSION"
	else
		echo "$MSG_ERROR LibreOffice $LO_VERSION"
	fi
	
	if [ $LO_INSTALL_LANG_PACK_SUCCESS  -eq 0 ] ; then
		echo "$MSG_SUCCESS LibreOffice Language-pack $LO_VERSION"
	else
		echo "$MSG_ERROR LibreOffice Language-pack $LO_VERSION"
	fi
fi

#instalacao google chrome
if [ $CHROME_INSTALL == true ]; then
	#download
	echo "$MSG_DOWNLOADING Google Chrome"
	sleep 2

	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i386
	else
		ARCH2=amd64
	fi

	#baixar chrome ultima versao
	wget --output-document=google-chrome-stable_current_$ARCH2.deb https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH2.deb 

	echo "$MSG_UNISTALL Google Chrome" #removendo versão anterior
	sleep 2

	dpkg -r google-chrome-stable > /dev/null 2>&1

	echo "$MSG_INSTALLING Google Chrome" #install 
	gdebi google-chrome-stable_current_$ARCH2.deb --n > /dev/null 2>&1 #auto accept 
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Google Chrome" #removendo arquivos pós-instalação
		rm -rf google-chrome* > /dev/null 2>&1
		sleep 1
	fi

	#verifica se  foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Google Chrome"
	else
		echo "$MSG_ERROR Google Chrome"
	fi
fi

#instalacao firefox
if [ $FIREFOX_INSTALL == true ]; then
	#download
	echo "$MSG_DOWNLOADING Firefox"
	sleep 2

	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i686
	else
		ARCH2=x86_64
	fi		
	
	#baixar firefox ultima versao
	wget --output-document=firefox-$FIREFOX_VERSION.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-$ARCH2/pt-BR/firefox-$FIREFOX_VERSION.tar.bz2

	echo "$MSG_UNISTALL Firefox"
	sleep 2
	
	rm -rf /opt/firefox* > /dev/null 2>&1

	echo "$MSG_INSTALLING Firefox"
	sleep 2

	tar -vxjpf firefox-$FIREFOX_VERSION.tar.bz2 -C /opt/ > /dev/null 2>&1
	chmod 777 -R /opt/firefox/

	rm -rf /bin/firefox > /dev/null 2>&1 #remove link simbolico p/ binarios
	ln -s /opt/firefox/firefox /bin/firefox #cria link simbolico p/ binarios
	INSTALL_SUCCESS=$?	

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Firefox" #removendo arquivos pós-instalação
		rm -rf firefox*
	fi

	#verifica se  foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Firefox $FIREFOX_VERSION"
	else
		echo "$MSG_ERROR Firefox"
	fi
fi

#instalacao virtualbox
if [ $VIRTUAL_BOX_INSTALL == true ]; then
	#comentar linha em /etc/apt/sources.list referente a atualização por cd
	sed -i "s,deb cdrom:,#deb cdrom:,g"  /etc/apt/sources.list  > /dev/null 2>&1

	#adicionando repository
	echo "deb http://download.virtualbox.org/virtualbox/debian $DISTRO_NAME contrib" | tee /etc/apt/sources.list.d/virtualbox.list  > /dev/null 2>&1
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -  > /dev/null 2>&1
	#apt-key add oracle_vbox.asc
	
	echo "$MSG_UNISTALL VirtualBox"
	sleep 2

	apt-get --purge remove virtualbox* -y  > /dev/null 2>&1
	sleep 1

	apt-get update  > /dev/null 2>&1

	sleep 2
	echo "$MSG_DOWNLOADING VirtualBox"

	sleep 2
	echo "$MSG_INSTALLING VirtualBox"
	
	apt-get install virtualbox-5.0 --force-yes -y  > /dev/null 2>&1

	INSTALL_SUCCESS=$?
	#verifica se  foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS VirtualBox"
	else
		echo "$MSG_ERROR VirtualBox"
	fi
fi

#instalacao drop-box
if [ $DROP_BOX_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i386
	else
		ARCH2=amd64
	fi	
	echo "$MSG_DOWNLOADING Dropbox"
	sleep 2
	wget --output-document=dropbox-$DROP_BOX_DATE'_'$ARCH2.deb https://www.dropbox.com/download?dl=packages/$DISTRO_ID/dropbox'_'$DROP_BOX_DATE'_'$ARCH2.deb
	
	echo "$MSG_UNISTALL Dropbox"
	sleep 2

	apt-get --purge remove dropbox* -y > /dev/null 2>&1
	
	echo "$MSG_INSTALLING Dropbox"
	gdebi dropbox-$DROP_BOX_DATE'_'$ARCH2.deb --n  > /dev/null 2>&1 #auto accept
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Dropbox"
		rm -rf dropbox-*
		sleep 1
	fi

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Dropbox"
	else
		echo "$MSG_ERROR Dropbox"
	fi
fi


#instalacao mega-cz
if [ $MEGA_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i386
	else
		ARCH2=amd64
	fi	
	#verifica nome distro
	if [ $DISTRO_ID == ubuntu ]; then
		DISTRO_ID2=xUbuntu
		DISTRO_RELEASE2=$DISTRO_RELEASE
	elif [ $DISTRO_ID == debian ]; then
		DISTRO_ID2=Debian
		DISTRO_RELEASE2=${DISTRO_RELEASE//.*/.0}	#substituiu tudo que tiver apartir do .* por .0 necessário porque link p/ donwnload no formato 7.0 8.0
	else
		DISTRO_ID2=other
	fi

	if [ $DISTRO_ID2 != other ]; then
		#verifica release do sistema.. p/ download so número c/ terminacao 0 nao pode ser ex: debian 8.2 tem que ser 8.0

		echo "$MSG_DOWNLOADING Mega"
		sleep 2
		wget --output-document=mega-'_'$ARCH2.deb  https://mega.nz/linux/MEGAsync/$DISTRO_ID2'_'$DISTRO_RELEASE2/$ARCH2/megasync'-'$DISTRO_ID2'_'$DISTRO_RELEASE2'_'$ARCH2.deb

	
		echo "$MSG_UNISTALL Mega"
		sleep 2

		apt-get --purge remove mega* -y > /dev/null 2>&1
	
		echo "$MSG_INSTALLING Mega"

		gdebi mega-'_'$ARCH2.deb --n  > /dev/null 2>&1 #auto accept
		INSTALL_SUCCESS=$?

		if [ $DEL_FILES_AFTER_INSTALL == true ]; then
			echo "$MSG_DELETE Mega"
			rm -rf mega-*
			sleep 1
		fi

		#verifica se foi instalado com sucesso
		if [ $INSTALL_SUCCESS -eq 0 ]; then
			echo "$MSG_SUCCESS Mega"
		else
			echo "$MSG_ERROR Mega"
		fi
	else
		echo 'Other System.. Please do the download manual on: https://mega.nz/linux/'
	fi
fi


#instalacao mysqlworkbench
if [ $MYSQL_WORKBENCH_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i386
	else
		ARCH2=amd64
	fi	

	#verifica nome distro
	if [ $DISTRO_ID == ubuntu ]; then
		DISTRO_ID2=1ubu$DISTRO_RELEASE
	elif [ $DISTRO_ID == debian ]; then
		DISTRO_ID2=1ubu1504
	else
		DISTRO_ID2=other
	fi

	if [ $DISTRO_ID2 != other ]; then

		echo "$MSG_DOWNLOADING MySQL Workbench"
		sleep 2

		wget --output-document=mysql-workbench-$MYSQL_WORKBENCH_VERSION-$ARCH2.deb  http://ftp.kaist.ac.kr/mysql/Downloads/MySQLGUITools/mysql-workbench-community-$MYSQL_WORKBENCH_VERSION-$DISTRO_ID2-$ARCH2.deb
		
		echo "$MSG_DOWNLOADING libjpeg8"
		sleep 2
		#dependencia necessaria libjpeg8
		wget --output-document=libjpeg8_8d1-2_$ARCH2.deb  http://ftp.us.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d1-2_$ARCH2.deb
		
		echo "$MSG_UNISTALL MySQL Workbench"
		sleep 2

		apt-get --purge remove mysql* -y > /dev/null 2>&1
	
		echo "$MSG_INSTALLING MySQL Workbench"
		
		#instalar dependencia
		gdebi libjpeg8_8d1-2_$ARCH2.deb  --n  > /dev/null 2>&1 #auto accept
		INSTALL_LIB_SUCCESS=$?

		gdebi mysql-workbench-$MYSQL_WORKBENCH_VERSION-$ARCH2.deb --n  > /dev/null 2>&1 #auto accept
		INSTALL_MYSQL_SUCCESS=$?

		if [ $DEL_FILES_AFTER_INSTALL == true ]; then
			echo "$MSG_DELETE MySQL Workbench"
			rm -rf mysql-workbench*
			rm -rf libjpeg8*
			sleep 1
		fi

		#verifica se foi instalado com sucesso
		if [ $INSTALL_LIB_SUCCESS -eq 0 ]; then
			echo "$MSG_SUCCESS Biblioteca libjpeg8"
		else
			echo "$MSG_ERROR Biblioteca libjpeg8"
		fi

		#verifica se foi instalado com sucesso
		if [ $INSTALL_MYSQL_SUCCESS -eq 0 ]; then
			echo "$MSG_SUCCESS MySQL Workbench"
		else
			echo "$MSG_ERROR MySQL Workbench"
		fi
	else
		echo 'Other System.. Please do the download manual on: http://dev.mysql.com/downloads/workbench/'
	fi
fi

#instalacao vagrant
if [ $VAGRANT_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i686
	else
		ARCH2=x86_64
	fi	
	echo "$MSG_DOWNLOADING Vagrant"
	sleep 2

	wget --output-document=vagrant-$VAGRANT_VERSION-$ARCH2.deb https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/vagrant'_'$VAGRANT_VERSION'_'$ARCH2.deb
	
	echo "$MSG_UNISTALL Vagrant"
	sleep 2

	apt-get --purge remove vagrant* -y > /dev/null 2>&1
	
	echo "$MSG_INSTALLING Vagrant"
	gdebi vagrant-$VAGRANT_VERSION-$ARCH2.deb --n  > /dev/null 2>&1 #auto accept
	INSTALL_SUCCESS1=$?

	#install plugin vagrant-vbguest
	vagrant plugin install vagrant-vbguest
	INSTALL_SUCCESS2=$?


	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Vagrant"
		rm -rf vagrant*
		sleep 1
	fi
	
	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS1 -eq 0 ]; then
		echo "$MSG_SUCCESS Vagrant"
	else
		echo "$MSG_ERROR Vagrant"
	fi
	
	#verifica se plugin vbguest foi instalado com sucesso
	if [ $INSTALL_SUCCESS2 -eq 0 ]; then
		echo "$MSG_SUCCESS Vagrant vbguest"
	else
		echo "$MSG_ERROR Vagrant vbguest"
	fi
fi

#instalacao spotify
if [ $SPOFITY_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i386
	else
		ARCH2=amd64
	fi	
	echo "$MSG_DOWNLOADING Spotify"
	sleep 2

	wget --output-document=libcrypt11_1.5.0.deb http://ftp.us.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u3_$ARCH2.deb
	dpkg -i libcrypt11_1.5.0.deb #-y é preciso?????

	#add key	
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

	#add repository	
	echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list

	echo $MSG_UPDATING_SYSTEM
	sleep 2
	#update system
	apt-get update  -y > /dev/null 2>&1
	
	apt-get install spotify-client -y 
	INSTALL_SUCCESS=$?

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Spotify"
	else
		echo "$MSG_ERROR Spotify"
	fi
fi


#instalacao netbeans
if [ $NETBEANS_INSTALL == true ]; then
	if [ $ARCH != 'x86_64' ]; then #sistema 32bit
		ARCH2=i686
	else
		ARCH2=x86_64
	fi	
	echo "$MSG_DOWNLOADING Netbeans"
	sleep 2

	wget --output-document=netbeans-$NETBEANS_VERSION.sh http://download.netbeans.org/netbeans/$NETBEANS_VERSION/final/bundles/netbeans-$NETBEANS_VERSION-linux.sh
	
	echo "$MSG_UNISTALL Netbeans"
	sleep 2

	apt-get --purge remove netbeans* -y > /dev/null 2>&1
	
	echo "$MSG_INSTALLING Netbeans"

	chmod +x netbeans-$NETBEANS_VERSION.sh
	./netbeans-$NETBEANS_VERSION.sh #-y > /dev/null 2>&1
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Netbeans"
		rm -rf netbeans*
		sleep 1
	fi

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS NetBeans"
	else
		echo "$MSG_ERROR NetBeans"
	fi
fi

#instalacao phpStorm
if [ $PHP_STORM_INSTALL == true ]; then
	echo "$MSG_DOWNLOADING phpStorm"
	sleep 2
	wget --output-document=phpStorm-$PHP_STORM_VERSION.tar.gz http://download.jetbrains.com/webide/PhpStorm-$PHP_STORM_VERSION.tar.gz
	
	echo "$MSG_UNISTALL phpStorm"
	rm -rf /usr/bin/phpstorm
	sleep 2

	if [ ! -d $PATH_TO_INSTALL ]; then	#nao existe pasta
		mkdir "$PATH_TO_INSTALL"
		chmod 777 -R "$PATH_TO_INSTALL"
	fi

	#verifica se existe instalacao anterior cria bkp 
	if [ ! -d "$PATH_TO_INSTALL/phpStorm/" ]; then	#nao existe
		mkdir "$PATH_TO_INSTALL/phpStorm"
	else
		if [ -d "$PATH_TO_INSTALL/phpStorm/" ]; then
			mv $PATH_TO_INSTALL/phpStorm/ $PATH_TO_INSTALL/phpStorm_old
		fi
		mkdir "$PATH_TO_INSTALL/phpStorm"
		chmod 777 -R "$PATH_TO_INSTALL/phpStorm/"
	fi
	
	echo "$MSG_INSTALLING phpStorm"
	tar xvzf phpStorm-$PHP_STORM_VERSION.tar.gz -C  "$PATH_TO_INSTALL/phpStorm/" > /dev/null 2>&1
	chmod 777 -R "$PATH_TO_INSTALL/phpStorm/"
	chmod +x $PATH_TO_INSTALL/phpStorm/*/bin/phpstorm.sh
	ln -s $PATH_TO_INSTALL/phpStorm/*/bin/phpstorm.sh /usr/bin/phpstorm
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE phpStorm"
		rm -rf phpStorm*
		sleep 1
	fi

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS phpStorm"
	else
		echo "$MSG_ERROR phpStorm"
	fi
fi

#instalacao evoluspencil
if [ $EVOLUS_PENCIL_INSTALL == true ]; then
	echo "$MSG_DOWNLOADING Evoluspencil"
	sleep 2
#	wget --output-document=evoluspencil-$EVOLUS_PENCIL_VERSION.deb https://evoluspencil.googlecode.com/files/evoluspencil'_'$EVOLUS_PENCIL_VERSION'_'all.deb
	wget --output-document=evoluspencil-$EVOLUS_PENCIL_VERSION.deb https://evoluspencil.googlecode.com/files/evoluspencil_2.0.2_amd64.deb
	
	echo "$MSG_UNISTALL Evoluspencil"
	apt-get --purge remove evoluspencil* -y > /dev/null 2>&1
	sleep 2

	
	echo "$MSG_INSTALLING Evoluspencil"
	gdebi evoluspencil-$EVOLUS_PENCIL_VERSION.deb --n # > /dev/null 2>&1 #auto accept
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Evoluspencil"
		rm -rf evoluspencil*
		sleep 1
	fi

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Evoluspencil"
	else
		echo "$MSG_ERROR Evoluspencil"
	fi
fi

#instalacao stremio
if [ $STREMIO_INSTALL == true ]; then
	echo "$MSG_DOWNLOADING Stremio"
	sleep 2
	wget --output-document=stremio-$STREMIO_VERSION.tar.gz http://dl.strem.io/Stremio$STREMIO_VERSION.linux.tar.gz
        wget --output-document=stremio.png http://www.strem.io/3.0/stremio-white-small.png
	
	echo "$MSG_UNISTALL Stremio"
	rm -rf /usr/local/programas/stremio
	rm -rf /usr/bin/stremio
	rm -ff /usr/bin/Stremio-runtime
	sleep 2

	
	echo "$MSG_INSTALLING Stremio"
	mkdir $PATH_TO_INSTALL/stremio
        tar xvzf stremio-$STREMIO_VERSION.tar.gz -C  "$PATH_TO_INSTALL/stremio/" > /dev/null 2>&1
	chmod 777 -R "$PATH_TO_INSTALL/stremio/"
	mv stremio.png $PATH_TO_INSTALL/stremio/
	chmod +x $PATH_TO_INSTALL/stremio/Stremio.sh
	#cria links
	ln -s $PATH_TO_INSTALL/stremio/Stremio.sh /usr/bin/stremio
	ln -s $PATH_TO_INSTALL/stremio/Stremio-runtime /usr/bin/Stremio-runtime
	
	INSTALL_SUCCESS=$?

	if [ $DEL_FILES_AFTER_INSTALL == true ]; then
		echo "$MSG_DELETE Stremio"
		rm -rf stremio*
		sleep 1
	fi

	#verifica se foi instalado com sucesso
	if [ $INSTALL_SUCCESS -eq 0 ]; then
		echo "$MSG_SUCCESS Stremio"
	else
		echo "$MSG_ERROR Stremio"
	fi
fi


