#!/bin/bash
#to run this command type: sh drush.sh sitename absolutepath

#enter server specific values below
mysqluser=root
mysqlpass=[MYSQLPASS]
drupaluser=[DRUPALUSER]
drupalpass=[DRUPALPASS]
drupalmail=[DRUPALEMAIL]


if [ -e $1 ];
then
 echo "ERROR: please supply site name ie: domainname"
 exit 1
fi

if [ -e $2 ];
then
 echo "ERROR: please supply the sites absolute path ie: /var/www/domainname"
 exit 1
fi

#show script initiation and request sudo credentials
sudo echo "Starting scripts"
#download drupal
drush make drupal7.make $2
#rename drupal directory
cd $2
#echo "create database $1;" | mysql
drush site-install standard --db-url=mysql://$mysqluser:$mysqlpass\@localhost/$1 --site-name=$1 --account-name=$drupaluser --account-pass="$drupalpass" --account-mail=$drupalmail -y

#create nginx config
sudo cp /etc/nginx/conf.d/nginx.tpl /etc/nginx/conf.d/$1.conf
sudo sed -i "s/servername/$1/g" /etc/nginx/conf.d/$1.conf
escpath=${2//"/"/"\/"} 
sudo sed -i "s/absolutepath/$escpath/g" /etc/nginx/conf.d/$1.conf

#restart services
sudo service nginx reload

