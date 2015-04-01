#!/usr/bin/env bash

# Variables
WEBSITE="${1}"
URL="${2}"
ROOT_PWD="${3}"
IP="${4}"

# Final configuration
# --------------------
echo "***** Create vhost *****"
cp /vagrant/config/vhost /etc/apache2/sites-available/$WEBSITE.conf
sed -i "s/_URL_/$URL/g" /etc/apache2/sites-available/$WEBSITE.conf
sed -i "s/_WEBSITE_/$WEBSITE/g" /etc/apache2/sites-available/$WEBSITE.conf
a2ensite $PROJECT
echo "$IP www.$URL $URL" >> /etc/hosts
echo "***** Change rights *****"
chmod 777 -R /var/cache
chmod 777 -R /var/log
chmod 777 -R /var/www/$WEBSITE/app/cache
chmod 777 -R /var/www/$WEBSITE/app/logs
echo "***** Create database *****"
echo "CREATE DATABASE $PROJECT" | mysql -u root -p$ROOT_PWD
echo "***** Restart service Apache2 *****"
service apache2 restart