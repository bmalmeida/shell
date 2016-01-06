#!/bin/bash
# Script instalador do java jdk
# Baixa, descompacta instala a versão mais recente do java Sun / Oracle //modificar
######################## VARIAVEIS ####################################
DISTRO_NAME=`lsb_release -c` #comando retonara Codename: nome_distribuicao
DISTRO_NAME=${DISTRO_NAME#'Codename:'}	#remove o que tiver no segundo parametro
SO='debian' #debian or ubuntu
JAVA_VERSION=8

#######################################################################
echo "
##########################

Installation Java Oracle JDK 
System: $SO
Version Java: $JAVA_VERSION

##########################
"
sleep 2

#debian
if [ $SO == 'debian' ]; then

	#comentar linha em /etc/apt/sources.list referente a atualização por cd
	sed -i "s,deb cdrom:,#deb cdrom:,g"  /etc/apt/sources.list

	clear 

	#remover versao openjdk
	echo ".... Removendo versão open-jdk "
	sleep 1
	apt-get purge --remove openjdk* -y

	#remover versao openjdk
	echo ".... Removendo versão oracle-jdk "
	sleep 1
	apt-get remove oracle-java* -y

	#adicionando repository
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

	clear
	echo ".... Updating system"
	sleep 1
	apt-get update

	## Baixando pacote tar.gz.

	#se versao >= 6 e <= 9; versoes c/ repositório
	if [ $JAVA_VERSION -ge 6 ] && [ $JAVA_VERSION -le 9 ]; then
		 #accept auto license
		 echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true |  /usr/bin/debconf-set-selections 
		 apt-get install oracle-java$JAVA_VERSION-installer -y
		 apt-get install oracle-java$JAVA_VERSION-set-default -y
 	else
		echo ''
		echo '#######################################################################'
		echo 'VERSAO INVÁLIDA!!!!!!'
	fi

#ubuntu
elif [ $SO == 'ubuntu' ]; then
	#comentar linha em /etc/apt/sources.list referente a atualização por cd
	sed -i "s,deb cdrom:,#deb cdrom:,g"  /etc/apt/sources.list

	clear 

	#remover versao openjdk
	echo ".... Removendo versão open-jdk "
	sleep 1
	apt-get purge --remove openjdk* -y

	#remover versao openjdk
	echo ".... Removendo versão oracle-jdk "
	sleep 1
	apt-get remove oracle-java* -y

	#added repository
	echo ".... adding repository"
	add-apt-repository ppa:webupd8team/java -y 

	clear
	echo ".... Updating system"
	sleep 1
	apt-get update


	#se versao >= 6 e <= 9; versoes c/ repositório
	if [ $JAVA_VERSION -ge 6 ] && [ $JAVA_VERSION -le 9 ]; then
		 #accept auto license
		 echo oracle-java$JAVA_VERSION-installer shared/accepted-oracle-license-v1-1 select true |  /usr/bin/debconf-set-selections 
		 apt-get install oracle-java$JAVA_VERSION-installer -y
		 apt-get install oracle-java$JAVA_VERSION-set-default 
 	else
		echo ''
		echo '#######################################################################'
		echo 'VERSAO INVÁLIDA!!!!!!'
	fi
else
	echo 'Sistema Inválido'
fi
