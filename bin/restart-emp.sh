#!/usr/bin/env bash
################################################################################
# Service script
################################################################################


# Service setup ################################################################
# Restart Web Server
echo "Restarting Web Server ..."
service nginx restart

# Restart PHP
echo "Restarting PHP ..."
service php5-fpm restart

# Restart MySQL
echo "Restarting MySQL ..."
service mysql restart
################################################################################

echo 'Restart script complete!'
echo "-------------------------------------------------------------------------"
echo 'Check your browser at http://localhost:8080/ to confirm.'