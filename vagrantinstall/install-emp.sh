#!/usr/bin/env bash
################################################################################
# Install Nginx, MySQL, and PHP-FPM
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


# Install Nginx ################################################################
inst 'Nginx' nginx

# overwrite the nginx default server configuration for the vagrant app
sudo cat > /etc/nginx/sites-available/default <<'EOF'
server {
  server_name localhost;
  root /vagrant/public;

  # Enable compression, this will help if you have for instance advagg‎ module
  # by serving Gzip versions of the files.
  gzip_static on;

  location = /favicon.ico {
    log_not_found off;
    access_log off;
  }

  location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }

  # This matters if you use drush prior to 5.x
  # After 5.x backups are stored outside the Drupal install.
  #location = /backup {
  #        deny all;
  #}

  # Very rarely should these ever be accessed outside of your lan
  location ~* \.(txt|log)$ {
    allow 192.168.0.0/16;
    deny all;
  }

  location ~ \..*/.*\.php$ {
    return 403;
  }

  # No no for private
  location ~ ^/sites/.*/private/ {
    return 403;
  }

  # Block access to "hidden" files and directories whose names begin with a
  # period. This includes directories used by version control systems such
  # as Subversion or Git to store control files.
  location ~ (^|/)\. {
    return 403;
  }

  location / {
    # This is cool because no php is touched for static content
    try_files $uri @rewrite;
  }

  location @rewrite {
    # You have 2 options here
    # For D7 and above:
    # Clean URLs are handled in drupal_environment_initialize().
    rewrite ^ /index.php;
    # For Drupal 6 and below:
    # Some modules enforce no slash (/) at the end of the URL
    # Else this rewrite block wouldn't be needed (GlobalRedirect)
    #rewrite ^/(.*)$ /index.php?q=$1;
  }

  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_intercept_errors on;
  }

  # Fighting with Styles? This little gem is amazing.
  # This is for D6
  #location ~ ^/sites/.*/files/imagecache/ {
  # This is for D7 and D8
  location ~ ^/sites/.*/files/styles/ {
    try_files $uri @rewrite;
  }

  location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires max;
    log_not_found off;
  }
}
EOF

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
inst 'Installing PHP-FPM' php5-fpm php5-mysql php5-common php5-json php5-curl php5-gd php5-mcrypt php5-imagick php5-imap php5-mcrypt php5-memcached
sudo ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/mcrypt.ini
sudo php5enmod mcrypt
echo Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/
mv /usr/local/bin/composer.phar /usr/local/bin/composer
mkdir /home/vagrant/.composer

echo "Installing Composer dependencies in /vagrant/composer.json to /vagrant/vendor"
composer install -d /vagrant
################################################################################

echo "Webstack installation script complete!"
echo "-------------------------------------------------------------------------"
