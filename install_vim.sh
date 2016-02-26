#!/bin/bash
#script to install and configure vim with plugins
#see more on https://github.com/fredericomartini/vimrc

USER=`ls /home/`
HOME_DIR="/home/$USER"


#install vim and vim-gnome
#apt-get install vim vim-gnome -y

#install syntax colorized to vim

#configure vim
function configure_vim(){
    #clone to home_dir
        git clone https://github.com/fredericomartini/vimrc.git $HOME_DIR/.vim_runtime
            #copy to root dir
                cp -R $HOME_DIR/.vim_runtime /root/

                    #script install home_dir
                        sh $HOME_DIR/.vim_runtime/install_awesome_vimrc.sh

                            #script install root_dir
                                sh /root/.vim_runtime/install_awesome_vimrc.sh
                                 
    #modify my_configs.vim  

    cat > $HOME_DIR/.vim_runtime/my_configs.vim <<EOF
    colorscheme peaksea
    backgroud = light
   
EOF
    #configure root settings
    cp -R $HOME_DIR/.vim_runtime/my_configs.vim /root/.vim_runtime/
}

function install_YouCompleteMe(){
#install dependency
apt-get install build-essential cmake python-dev

#YouCompleteMe
#git clone https://github.com/Valloric/YouCompleteMe.git $HOME_DIR/.vim_runtime/sources_non_forked/YouCompleteMe

cd $HOME_DIR/.vim_runtime/sources_non_forked/YouCompleteMe/

#submodules
git submodule update --init --recursive

#compilling YCM with semantic support for C-family languages
./install.py --clang-completer

#compilling YCM without semantic support for C-family languages
#./install.py

}



#configure_vim

install_YouCompleteMe