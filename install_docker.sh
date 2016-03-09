#!/bin/bash
#steps
#install Docker Engine
#run a software image in a container
#browse for an image on Docker Hub
#create your own image and run it in a container
#create a Docker Hub account and an image repository
#create an image of your own
#push your image to Docker Hub for others to use

################## VARIABLES ####################
USER_NAME='Frederico Martini'
USER_EMAIL='fredmalmeida@gmail.com'
PROJECT_DIR=/home/fred/Docker/
APPLICATION_NAME=app

install (){

    #Must installed curl

    #(verify_isntallation) adicionar
    INSTALLED=`/bin/bash verify_installation.sh curl`

    #not installed
    if [ ! $INSTALLED -eq 0 ]; then 
        sudo apt-get update && sudo apt-get install curl
    fi


    #get latest Docker packege

    curl -fsSL https://get.docker.com/ | sh

    #Note: If your company is behind a filtering proxy, you may find that the apt-key command fails for the Docker repo during installation. To work around this, add the key directly using the following:
    curl -fsSL https://get.docker.com/gpg | sudo apt-key add -

    #add a user to docker group
    sudo usermod -aG docker fred

    #start service docker
    sudo service docker start

    #verify docker is installed correctly
    docker run hello-world

}

create_nginx_docker_image () {
    #folder to nginx configuration
    mkdir images && cd images/ && mkdir nginx && cd nginx

    #create a DockerFile
    cat > Dockerfile <<EOF FROM phusion/baseimage
    MAINTAINER $USER_NAME <$USER_EMAIL>

    CMD ["/sbin/my_init"]

    RUN apt-get update && apt-get install -y python-software-properties
    RUN add-apt-repository ppa:nginx/stable
    RUN apt-get update && apt-get install -y nginx

    RUN echo "daemon off;" >> /etc/nginx/nginx.conf
    RUN ln -sf /dev/stdout /var/log/nginx/access.log
    RUN ln -sf /dev/stderr /var/log/nginx/error.log

    RUN mkdir -p /etc/service/nginx
    ADD start.sh /etc/service/nginx/run
    RUN chmod +x /etc/service/nginx/run

    EXPOSE 80

    RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF
    
    #create a 
    cat > start.sh <<EOF
    #!/usr/bin/env bash
    service nginx start

EOF
    
    #build the docker
    docker build -t tutorial/nginx .

}

create_index_file (){
    if [ -d "$PROJECT_DIR$APPLICATION_NAME/src/" ]; then
        #bkp oldest content
        mv $PROJECT_DIR$APPLICATION_NAME/src/ $PROJECT_DIR$APPLICATION_NAME/src_bkp
    fi

    mkdir src && cd src 
    mkdir public && cd public
    cat > index.html <<EOF
    It's working!
EOF

}
create_structure (){
    #project  folder not exist
    if [ ! -d $PROJECT_DIR ]; then
        echo '!-d'
        mkdir $PROJECT_DIR && cd $PROJECT_DIR
        mkdir $APPLICATION_NAME && cd $APPLICATION_NAME
    else #project folder exist
        #app folder not exist
        if [ ! -d $APPLICATION_NAME/ ]; then
             mkdir $APPLICATION_NAME && cd $APPLICATION_NAME
        fi
    fi
    create_index_file
}

main () {
    
#    create_nginx_docker_image
    #download PHP-FPM docker image
#    docker pull nmcteam/php56
    #download MySQL docker image
#    docker pull sameersbn/mysql

    #create the structure 
    create_structure

}   

#main
install

