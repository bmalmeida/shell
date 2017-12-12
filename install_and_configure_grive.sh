#!/bin/bash
#
# Client Google Drive
#

#variables
USER=$(who | cut -d" " -f1)
HOME_DIR="/home/$USER"
REPO='https://github.com/Grive/grive'
SINC_FOLDER='/DATA/Cloud/fredmalmeida@gmail.com'
SCRIPT_SINC_NAME='sinc-gmail'

# Na primeira vez que for sincronizar, com o terminal aberto dentro da pasta, execute: 
# cd $SINC_FOLDER
# sudo grive -a 
# Acesse o link que o programa irá gerar, copie o código que receberá em seu navegador e cole de volta no Grive que ficou aberto no terminal aguardando seu retorno. 
# Com isso, iniciará o processo de sincronismo, conforme o download de seus arquivos forem concluindo, já será possível manuseá-los. 
# Sempre que quiser sincronizar novamente (salvar ou baixar novas alterações), no terminal, acesse sua pasta e rode o comando:


function install(){

    if [! -d "$HOME_DIR/.grivegit" ]; then
        sudo mkdir "$HOME_DIR/.grivegit"
    fi

    cd ${HOME_DIR}/.grivegit

    git clone https://github.com/Grive/grive

    #install dependencies
    sudo apt-get install cmake build-essential libgcrypt11-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev -y

    #repo
    cd grive

    #buils.. compile
    dpkg-buildpackage -j4
    mkdir build && cd build
    cmake ..
    make -j4
    sudo make install

    #criar script p/ sicronia automática
    addCronJob

}

function createScriptSinc(){
#script to run Crontab
cat <<EOF > /bin/${SCRIPT_SINC_NAME}
#!/bin/bash

cd  ${SINC_FOLDER}

#sinc
grive

EOF

}

function addCronJob(){
#Crontab
sed -in -e '$a\#script sinc google drive\n*/1 * * * * root /bin/'${SCRIPT_SINC_NAME} /etc/crontab
}


function main() {
install
createScriptSinc
addCronJob
}

main
