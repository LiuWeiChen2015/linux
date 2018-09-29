#!/bin/bash
read -p '输入FTP地址(请输入完整目录) ' ftp
read -p '输入文件传输地址IP ' ip
echo "[dvd]
name=dvd
baseurl=$ftp
enabled=1
gpgcheck=0" > /etc/yum.repos.d/dvd.repo
useradd nginx
yum install gcc make openssl-devel pcre-devel -y
wget ftp://${ip}/pub/tools.tar.gz -O /opt/tools.tar.gz
wget ftp://${ip}/pub/lnmp_soft.tar.gz -O /opt/lnmp_soft.tar.gz
wget ftp://${ip}/pub/isync.sh -O /opt/isync.sh
cd /opt/
tar -xf /opt/lnmp_soft.tar.gz
cd /opt/lnmp_soft/
tar -xf nginx-1.12.2.tar.gz
cd /opt/lnmp_soft/nginx-1.12.2
./configure --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make 
make install
cd /opt/lnmp_soft/
yum install php-fpm-5.4.16-42.el7.x86_64.rpm php php-mysql php-pecl-memcache.x86_64 -y
yum install mariadb mariadb-server -y
yum install memcached -y
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '69d' /usr/local/nginx/conf/nginx.conf
sed -i '69s/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
sed -i '45s/index.html/index.php index.html/' /usr/local/nginx/conf/nginx.conf
sed -i '224s/files/memcache/' /etc/php-fpm.d/www.conf
sed -i '225s/\/var\/lib\/php\/session/\"tcp:\/\/201\.1\.2\.5:11211\"/' /etc/php-fpm.d/www.conf
systemctl restart mariadb
systemctl restart php-fpm
systemctl restart memcached
/usr/local/nginx/sbin/nginx
cd /opt
tar -xf /opt/tools.tar.gz
cd /opt/tools/
tar -xf inotify-tools-3.13.tar.gz
cd inotify-tools-3.13/
./configure
make
make install
cd /opt/lnmp_soft/php_scripts/
tar -xf php-memcached-demo.tar.gz
cd php-memcached-demo/
cp -pR ./* /usr/local/nginx/html/
