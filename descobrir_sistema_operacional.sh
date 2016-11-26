#!/bin/bash
# descobrir informacoes do sistema operacional
DISTRO_INFO=`lsb_release  -i -c -r`						#Distributor ID: Ubuntu Release: 14.04 Codename: trusty
DISTRO_ID=${DISTRO_INFO#'Distributor'*'ID:'}		        #Ubuntu Release: 14.04 Codename: trusty
DISTRO_ID=${DISTRO_ID%'Release:'*}					#Ubuntu
DISTRO_RELEASE=${DISTRO_INFO##*'Release:'}		#14.04 Codename: trusty
DISTRO_RELEASE=${DISTRO_RELEASE%'Codename:'*}   #14.04
DISTRO_NAME=${DISTRO_INFO##*'Codename:'}		#trusty


echo ' ######## DADOS DA DISTRIBUICAO ######## '
echo $DISTRO_ID
echo $DISTRO_RELEASE
echo  $DISTRO_NAME

