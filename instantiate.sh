#!/bin/bash
echo noauth = true >> /etc/mongodb.conf
service mongodb start
sleep 5
mongo --eval "db.getSiblingDB('learninglocker')"
sed -i "s/ll_staging/learninglocker/g" /var/www/learninglocker/app/config/database.php
sed -i 's|/var/www/html|/var/www/learninglocker/public|g' /etc/apache2/sites-available/000-default.conf
sed -i '/learninglocker/a <Directory /var/www/learninglocker>\nAllowoverride All\n</Directory>' /etc/apache2/sites-available/000-default.conf