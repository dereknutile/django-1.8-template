#!/usr/bin/env bash
################################################################################
# Service script
################################################################################


# Service setup ################################################################
# Restart Web Server
echo "Restarting Web Server ..."
service apache2 restart

# Restart PHP
echo "Restarting PHP ..."
service php5 restart

# Restart MySQL
echo "Restarting MySQL ..."
service mysql restart
################################################################################

echo 'Restart script complete!'
echo "-------------------------------------------------------------------------"
echo 'Check your browser at http://localhost:8080/ to confirm.'