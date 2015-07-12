#!/usr/bin/env bash
################################################################################
# Export full database
################################################################################

mysqldump -uroot -proot drupal_washco > /vagrant/sql/$(date +%Y-%m-%d-%H-%M-%S).sql

