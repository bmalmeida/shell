#!/bin/bash
# script p/ criar e montar partição DADOS automaticamente
#ls -lah /dev/disks/by-uuid/ OU blkid

################## VARIAVEIS #########################

UUID_DADOS_NOTE=278d477a-4479-4960-a141-1662e3c27142 # /dev/sda1 ext4 dados notebook
UUID_DADOS_CPU=f3d75426-464e-d101-c0c5-5026464ed101 # /dev/sda3 ext4 dados pc-desktop
FS_NOTE='ext4'
FS_CPU='ext4'
PATH_TO_MOUNT='/media/DADOS/'
OPTION_TO_MOUNT=desktop # desktop monta pc-desktop caso outro valor monta notebook
FILE='/etc/fstab'

if [ -e "$1" ]; then
    OPTION_TO_MOUNT=$1
fi
######################################################

#verifica se diretorio/pasta nao existe
if [ ! -d $PATH_TO_MOUNT ]; then
	#cria pasta
	mkdir $PATH_TO_MOUNT
else
	#verifica se esta montado
	mount | grep -q 'DADOS'
	if [ ! $? != 0 ]; then
		umount $PATH_TO_MOUNT
	fi
fi

#permissao escrita
chmod 777 -R $PATH_TO_MOUNT

#pc-desktop
if [ $OPTION_TO_MOUNT == desktop ]; then
	#adiciona linha no arquivo /etc/fstab p/ montagem automatica no boot
	echo "#dados"  >> $FILE
	echo "UUID=$UUID_DADOS_CPU $PATH_TO_MOUNT  $FS_CPU    defaults        1 2" >> $FILE
#notebook
else
	#adiciona linha no arquivo /etc/fstab p/ montagem automatica no boot
	echo "#dados"  >> $FILE
	echo "UUID=$UUID_DADOS_NOTE $PATH_TO_MOUNT  $FS_NOTE    defaults        1 2" >> $FILE
fi


#monta tudo 
mount -a


