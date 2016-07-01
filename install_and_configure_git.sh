#!/bin/bash
#
#check git intallation case not installed, install and configure aliases and difftool
#

#variables
USER=$(who | cut -d" " -f1)
PASSED_USER=$1
if [ -n "$PASSED_USER" ];then #user passed
	USER=$PASSED_USER
fi
HOME_DIR="/home/$USER"
GIT_USER='Frederico Martini'
GIT_EMAIL='fredmalmeida@gmail.com'

function verify_installation(){
	INSTALLED=$(which git)
	if [ -n "$INSTALLED" ]; then
		echo 0; #true
	else
	    install	
	fi
	return
}

function install(){
	#udpate
	clear
	echo 'git not installed, will be installed'
	sleep 2
	apt-get update && apt-get install git gitk git-flow meld -y #> /dev/null 2>&1
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
		#diff 
		dt = difftool -y
        #delete remote branch e push
        del-remote-branch = ! echo enter branch name && read BRANCH && git branch -D \$BRANCH && git branch --delete --remotes origin/\$BRANCH  && git push origin --delete \$BRANCH 

        #push a branch to remote
        push-remote-branch = ! echo enter branch name && read BRANCH && git push --set-upstream origin \$BRANCH
        #reset branch p/ o default, removendo tudo ..
        reset-to-default-and-remove-files =! git reset --hard origin/HEAD && git clean -d -f

	#difftool
	[diff]
	    tool = meld
EOF
}

function main() {
verify_installation
update_gitconfig

}

main
