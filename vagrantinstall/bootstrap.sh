#!/usr/bin/env bash
################################################################################
# Main shell script for provisioning the base vagrant box.
################################################################################
echo "-------------------------------------------------------------------------"
echo "Bootstrap script initialized ..."


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


# System updates and common libraries ##########################################
# Drop in ppa's here before the apt-get update later

# Ubuntu/Debian system update
echo "Updating Ubuntu ..."
apt-get -y update >/dev/null 2>&1
apt-get -y upgrade >/dev/null 2>&1

# Build essentials are required for some things like Redis
inst 'Build Essentials Development Tools' build-essential

# Install make
inst 'Make' make

# Install Mcrypt libraries
inst 'Mcrypt' mcrypt
################################################################################


# Miscellaneous apps and requirements ##########################################
# Install NodeJs
inst 'NodeJS' nodejs

# Install the Node Package Manager
inst 'Node Package Manager' npm

# Symlink node to nodejs for naming inconsistencies
ln -s /usr/bin/nodejs /usr/bin/node

# install With Bower, Grunt, and Gulp here
echo "Installing NPM packages ..."
npm install -g bower
npm install -g grunt
npm install -g gulp
################################################################################


# Git setup ####################################################################
# Install Git
inst 'Git' git
################################################################################


# PATH settings ################################################################
echo "Adding /vagrant/bin to path ..."
echo 'export PATH="/vagrant/bin:$PATH"' >> /home/vagrant/.bashrc
echo "Making /vagrant/bin/ scripts executable ..."
chmod +x /vagrant/bin/*.sh
echo "Adding /vagrant/vendor/bin to path."
echo 'export PATH="/vagrant/vendor/bin:$PATH"' >> /home/vagrant/.bashrc
################################################################################

echo 'Boostrap.sh complete!'
echo "-------------------------------------------------------------------------"
