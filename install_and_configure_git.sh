#!/bin/bash

#configurations --global to git

#variables
USER=`ls /home/`
HOME_DIR="/home/$USER"
INSTALLED=`which git`
GIT_USER='Frederico Martini'
GIT_EMAIL='fredmalmeida@gmail.com'

function verify_installation(){
INSTALLED=`which git`
if [ -n "$INSTALLED" ]; then
	echo 0; #true
else
	echo 1; #false
fi
return
}

function install(){
#udpate
clear
echo 'git not installed, will be installed'
sleep 2
apt-get update && apt-get install git -y #> /dev/null 2>&1
return $?

}

function update_gitconfig(){
#bkp .gitconfig if exists
if [ -f "$HOME_DIR/.gitconfig" ]; then
	mv "$HOME_DIR/.gitconfig" "$HOME_DIR/.gitconfig_bkp"
fi
#create file
cat > $HOME_DIR/.gitconfig <<EOF
[user]
        name = $GIT_USER
	email = $GIT_EMAIL
[alias]
        hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
        add-commit = ! echo enter filename \"'.'\" to all: && read FILE && echo enter commmit message: &&  read MSG && git add "\$FILE"  && git commit -am \"\$MSG\"
	add-commit-push = ! echo enter filename \"'.'\" to all: && read FILE && echo enter commmit message: &&  read MSG && git add "\$FILE"  && git commit -am \"\$MSG\" && git push
	st = status
	#rollback last commit
	rollback = reset --soft HEAD~1
EOF
}

#check git installation
if [ ! -n "$INSTALLED" ];then
	#udpate
	clear
	echo 'git not installed, will be installed'
	sleep 2
	apt-get update && apt-get install git -y > /dev/null 2>&1
	INSTALLED_SUCCESS=$?
	#installed success
	if [ ! $INSTALLED_SUCCESS -eq 0 ]; then
		echo 'Erro on installation'
		exit
	fi
fi

#check installation again
#not installed
if [ ! `verify_installation` -eq 0 ]; then
	if [ `install` -eq 0 ]; then #return true if install
		#update .giconfig		
		update_gitconfig
	else
		echo 'Erro: Not installed'
	fi
else
	#update .gitconfig
	update_gitconfig
fi
