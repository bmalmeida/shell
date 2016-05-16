#!/bin/bash

install_modulo_seg_caixa () {

    wget --output-document=modulo_seguranca.deb https://imagem.caixa.gov.br/banner/fgr/GBPCEFwr64.deb
    
    #update && install libs 
    apt-get update && apt-get install libnss3-tools libcurl3 -y
    sudo dpkg -i modulo_seguranca.deb -y

    #confirmacao que foi instalado com sucesso

    sleep 2
    clear
    echo " --- Confirme que módulo está instalado e rodando \n após fechar browser e tentar novamente---"
    ps -ef | grep warsaw

}

    install_modulo_seg_caixa

