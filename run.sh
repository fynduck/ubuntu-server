#!/usr/bin/env bash

echo "Locale install..."
##################
### LOCALE FIX ###
##################
export DEBIAN_FRONTEND=noninteractive

export LC_ALL="en_US.UTF-8"
apt-get install language-pack-ru

sudo cat >/etc/default/locale <<EOL
LANG="en_US.UTF-8"
LANGUAGE="en_EN:en"
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE=en_US.UTF-8
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES=en_US.UTF-8
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOL

sudo update-locale LANG=ru_RU.UTF-8

echo "Locale installed!"

if [[ $1 == true ]]; then
    echo "Nginx install..."
    #############
    ### NGINX ###
    #############
    sudo apt-get update -y
    sudo apt-get install nginx -y
    sudo service nginx stop

    echo "Nginx installed!"
fi

if [[ $2 == true ]]; then
    echo "Php install..."

    ###############
    ### PHP-FPM ###
    ###############
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install -y php7.2-fpm php7.2-mysql php7.2-zip php7.2-xml php7.2-mbstring php7.2-curl php7.2-imap
    rm /etc/php/7.2/fpm/conf.d/10-opcache.ini
    sudo apt install php7.2-pgsql
    sudo service php7.2-fpm restart

    echo "Php installed!"
fi

if [[ $3 == 'mysql' ]]; then
    echo "MYSQL install..."

    ######################
    ## MySQL Server 5.7 ##
    ######################

    # Download and Install the Latest Updates for the OS
    sudo apt update && apt upgrade -y

    # Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
    echo "mysql-server-5.7 mysql-server/root_password password root" | sudo debconf-set-selections
    echo "mysql-server-5.7 mysql-server/root_password_again password root" | sudo debconf-set-selections
    sudo apt install mysql-server -y

    # Change MySQL Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0
    sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

    # Update mysql Table root record to accept incoming remote connections
    mysql -uroot -proot -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

    # Restart MySQL Service
    service mysql restart

    echo "MYSQL installed!"
fi

if [[ $3 == 'postgres' ]]; then
    echo "POSTGRES install..."

    ##############
    ## POSTGRES ##
    ##############

    # Download and Install the Latest Updates for the OS
    sudo apt-get update

    sudo apt-get install postgresql postgresql-contrib

    echo "POSTGRES installed!"
fi

if [[ $3 == 'mongo' ]]; then
    ###############
    ### MONGODB ###
    ###############

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl enable mongod.service
    sudo service mongod start
fi

if [[ $4 == true ]]; then
    echo "Composer install..."

    ################
    ### COMPOSER ###
    ################

    sudo apt-get install composer -y

    echo "Composer installed..."
fi

if [[ $5 == true ]]; then
    echo "NODEJS & NPM install..."

    ####################
    ### NODEJS & NPM ###
    ####################

    sudo apt-get update
    sudo apt-get install -y nodejs
    sudo apt-get install -y npm

    sudo apt-get -y install zsh htop

    echo "NODEJS & NPM installed!"
fi

if [[ $6 == 'ufw' ]]; then
    echo "UFW install..."

    ###########
    ### UFW ###
    ###########

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow from 89.28.39.157 to any port 27017
    sudo ufw allow from 89.28.39.157 to any port 3306
    sudo ufw allow 22
    sudo ufw allow 80
    sudo ufw allow 443

    echo "UFW install..."

fi

if [[ $1 == 'nginx' ]]; then
    sudo service nginx start
fi

echo "FINISHED!!!"

exit;
