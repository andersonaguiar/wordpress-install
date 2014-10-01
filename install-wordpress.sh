#!/bin/bash

# ./install-wordpress.sh 

read -p "Where install, please inform the complete location: (Ex: /Users/andersonaguiar/Sites/) `echo $'\n> '`" directory
case $directory in
	'.' ) directory=$(pwd)
	   ;;
    '' ) echo "Please typing the directory." 
		 exit 1
esac

read -p "Database name: `echo $'\n> '`" db_name
case $db_name in
    '' ) echo "Please typing the database name." 
		 exit 1
esac

read -p "Database pass: `echo $'\n> '`" admin_pass
case $admin_pass in
    '' ) echo "Please typing the password." 
		 exit 1
esac

# read -p "Admin email: `echo $'\n> '`" admin_email
# case $admin_email in
#     '' ) echo "Please typing the email." 
# 		 exit 1
# esac

# read -p "Admin pass: `echo $'\n> '`" admin_pass
# case $admin_pass in
#     '' ) echo "Please typing the password." 
# 		 exit 1
# esac

read -p "Url for open: (Ex: http://localhost:8888/wordpress/) `echo $'\n> '`" url

# Validate input
# if [ $# != 4 ] then
#     echo "Usage: `basename $0` directory blog_title admin_email admin_passw"
#     exit 1
# fi

# The database user is the same as the database name.
db_user=$db_name
db_password=$admin_pass

# First check if the file has been ever downloaded
if test -f /tmp/latest.tar.gz 
then
    echo "File is already there."
# Download the file for the first time
else
    echo "Downloading file file for the first time"
    cd /tmp/ && wget "http://br.wordpress.org/latest-pt_BR.tar.gz"
fi

# Extract the installation archive
tar -C $directory -zxf /tmp/latest-pt_BR.tar.gz --strip-components=1

# Rename the default config file
mv $directory/wp-config-sample.php $directory/wp-config.php

# Substitute the default database values
sed -i '' "s/nomedoBD/$db_name/g" $directory/wp-config.php
sed -i '' "s/username_here/$db_user/g" $directory/wp-config.php
sed -i '' "s/password_here/$db_password/g" $directory/wp-config.php

# Get the salts and keys
# grep -A50 'table_prefix' $directory/wp-config.php > /tmp/wp-temp-config
# sed -i '' '/**#@/,/$p/d' $directory/wp-config.php
# cat /tmp/wp-temp-config >> $directory/wp-config.php && rm /tmp/wp-temp-config -f


# Create the database
mysql -uroot -proot -e "CREATE DATABASE $db_name"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON $db_name.* to '"$db_user"'@'localhost' IDENTIFIED BY '"$db_password"';"

# Populate the database
# php -r "
# include '"$directory"/wp-admin/install.php';
# wp_install('"$blog_title"', 'admin', '"$admin_email"', 1, '', '"$admin_pass"');
# " > /dev/null 2>&1

# Erase temp file
rm -rf /tmp/latest-pt_BR.tar.gz

# if defined open the url
if [ $url ]
then
	open $url'wp-admin/install.php'
fi