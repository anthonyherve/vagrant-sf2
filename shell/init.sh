#!/usr/bin/env bash

ROOT_PWD="${1}"

# Update box repositories
# -----------------------
echo "***** Update server *****"
apt-get update
apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php5
apt-get update

# Apache
# ------
echo "***** Install Apache2 *****"
apt-get install -y apache2
echo "***** Add ServerName to httpd.conf *****"
echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo "***** Enable mod_rewrite *****"
a2enmod rewrite

# Installation de PHP5
echo "***** Install PHP5 *****"
apt-get install -y php5
echo "***** Install PHP modules *****"
apt-get install -y php5-cli php5-mysql php5-curl php5-mcrypt php5-gd php-pear php5-xdebug php5-intl php-apc php5-sqlite
echo "***** Set timezone *****"
sed 's#;date.timezone\([[:space:]]*\)=\([[:space:]]*\)*#date.timezone\1=\2\"'"Europe/Paris"'\"#g' /etc/php5/apache2/php.ini > /etc/php5/apache2/php.ini.tmp
mv /etc/php5/apache2/php.ini.tmp /etc/php5/apache2/php.ini
sed 's#;date.timezone\([[:space:]]*\)=\([[:space:]]*\)*#date.timezone\1=\2\"'"Europe/Paris"'\"#g' /etc/php5/cli/php.ini > /etc/php5/cli/php.ini.tmp
mv /etc/php5/cli/php.ini.tmp /etc/php5/cli/php.ini
echo "***** Set short_open_tag *****"
sed 's#;short_open_tag\([[:space:]]*\)=\([[:space:]]*\)*#short_open_tag\1=\2\"'"Off"'\"#g' /etc/php5/apache2/php.ini > /etc/php5/apache2/php.ini.tmp
mv /etc/php5/apache2/php.ini.tmp /etc/php5/apache2/php.ini
sed 's#;short_open_tag\([[:space:]]*\)=\([[:space:]]*\)*#short_open_tag\1=\2\"'"Off"'\"#g' /etc/php5/cli/php.ini > /etc/php5/cli/php.ini.tmp
mv /etc/php5/cli/php.ini.tmp /etc/php5/cli/php.ini
echo "[xdebug]" >> /etc/php5/apache2/php.ini
echo "xdebug.max_nesting_level = 250" >> /etc/php5/apache2/php.ini
echo "[xdebug]" >> /etc/php5/cli/php.ini
echo "xdebug.max_nesting_level = 250" >> /etc/php5/cli/php.ini

# Installation de MySQL
echo "***** Install MySQL *****"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_PWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_PWD"
apt-get update
apt-get install -y mysql-server

# Essential packages
# ------------------
echo "***** Install essential packages *****"
apt-get install -y build-essential git-core vim curl
echo "***** Install composer *****"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp --filename=composer
cp /tmp/composer /usr/bin

# Add ant
echo "***** Install ant *****"
apt-get install ant

# Other config
rm -f /etc/apache2/sites-available/000-default.conf
unlink /etc/apache2/sites-enabled/000-default.conf

