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
a2ensite $WEBSITE
echo "$IP www.$URL $URL" >> /etc/hosts
echo "***** Change rights *****"
chmod 777 -R /var/cache
chmod 777 -R /var/log
mkdir /var/www/$WEBSITE/app/cache
chmod 777 -R /var/www/$WEBSITE/app/cache
mkdir /var/www/$WEBSITE/app/logs
chmod 777 -R /var/www/$WEBSITE/app/logs
echo "***** Create database *****"
echo "CREATE DATABASE $WEBSITE" | mysql -u root -p$ROOT_PWD
echo "***** Restart service Apache2 *****"
service apache2 restart