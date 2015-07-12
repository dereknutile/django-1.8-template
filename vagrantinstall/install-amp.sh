#!/usr/bin/env bash
################################################################################
# Install Apache2, MySQL, and PHP
################################################################################
echo "-------------------------------------------------------------------------"
echo "Webstack script initialized ..."


# Simple callable functions ####################################################
# Add an apt repo
function addrepo {
    echo 'Adding Repository' $1
    shift
    apt-add-repository -y install "$@" >/dev/null 2>&1
}

# Install using apt-get
function inst {
    echo 'Installing' $1
    shift
    # apt-get -y install "$@" >/dev/null 2>&1
    apt-get -y install "$@"
}
################################################################################


# Install Apache2 ##############################################################
inst 'Apache2' apache2

# overwrite the default Apache2 server configuration for the vagrant app
sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf
# Backup and link the default apache directory
sudo mv /var/www/html/ /var/www/html.original
sudo ln -s /vagrant/public /var/www/html
sudo a2enmod rewrite
################################################################################


# Database installs ############################################################
# Install SQLite
inst 'SQLite' sqlite3 libsqlite3-dev

# Install Redis
inst 'Redis' redis-server

# Install RabbitMQ Messaging
inst 'RabbitMQ' rabbitmq-server

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# MySQL Server
# inst 'MySQL Client Core' mysql-client-core-5.5
inst 'MySQL Server' mysql-server
inst 'MySQL Client Library' libmysqlclient-dev
################################################################################


# PHP setup ####################################################################
inst 'Installing PHP and libraries' php5-mysql php5 php5-cli libapache2-mod-php5 php5-mcrypt php5-common php5-json php5-curl php5-gd php5-imagick php5-imap php5-memcached
sudo php5enmod mcrypt
echo Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/
mv /usr/local/bin/composer.phar /usr/local/bin/composer
mkdir /home/vagrant/.composer

echo Composer update
/usr/local/bin/composer global update
################################################################################

echo "Webstack installation script complete!"
echo "-------------------------------------------------------------------------"
