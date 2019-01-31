#!/bin/bash -e
#
# This script sets up a linux instances bootstrapping for PHP application
#
# Usage:
# deploy-bootstrap.sh 
#
# Notes:
#
# Author:
#

yum install openssh-clients gihttpd24 \
    php71 php71-mbstring php71-gd php71-xml php71-pear \
    php71-fpm php71-mysql php71-pdo php71-opcache \
    make gcc-c++ gcc patch glibc-devel \
    git php71-mysqlnd mysql -y

# 1 - get node
curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -
yum -y install nodejs

# 2 - get yarn
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum -y install yarn

# 3 - gulp
npm install gulp-cli -g

# 4 - get/configure composer with php
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# echo $PATH
# echo "add the /usr/local/bin to root's PATH so we can exec composer"
# echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
# export PATH=$PATH:/usr/local/bin
# echo "new path: $PATH"
echo "run composer and grab drush"
/usr/local/bin/composer global require drush/drush

echo "----- updates completed : quick test apache, php -----"
service httpd start
chkconfig httpd on

echo "test - instance: " >> /var/www/html/index.php
curl http://169.254.169.254/latest/meta-data/local-hostname >> /var/www/html/index.php
echo "<br><br>PHP test (date): <?php echo date('l jS \of F Y h:i:s A'); ?>" >> /var/www/html/index.php
chown apache:apache /var/www/html/index.php
echo "----- DONE  -----"