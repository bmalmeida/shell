#!/bin/bash
# script p/ criar e montar partição DADOS automaticamente
#ls -lah /dev/disks/by-uuid/ OU blkid

################## VARIAVEIS #########################

UUID_DADOS_NOTE=278d477a-4479-4960-a141-1662e3c27142 # /dev/sda1 ext4 dados notebook
UUID_DADOS_CPU=1680085A6979127F # /dev/sda4 ntfs dados pc-desktop
FS_NOTE='ext4'
FS_CPU='ntfs-3g'
PATH_TO_MOUNT='/media/DADOS/'
OPTION_TO_MOUNT=1 # 1 monta pc-desktop caso outro valor monta notebook
FILE='/etc/fstab'

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
if [ $OPTION_TO_MOUNT == 1 ]; then
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


