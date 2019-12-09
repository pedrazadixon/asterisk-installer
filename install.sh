# instalacion dependencias primarias
yum -y install wget ca-certificates nano net-tools yum-utils
 
# instalacion de asterisk para octopus
cd /usr/local/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-15.5.0.tar.gz
tar -zxvf asterisk-*
cd asterisk-*
./contrib/scripts/install_prereq install
./configure
make menuselect.makeopts
./menuselect/menuselect --enable format_mp3 menuselect.makeopts
./menuselect/menuselect --enable CORE-SOUNDS-ES-GSM menuselect.makeopts
./menuselect/menuselect --enable EXTRA-SOUNDS-EN-GSM menuselect.makeopts
./menuselect/menuselect --enable res_config_mysql menuselect.makeopts
./menuselect/menuselect --enable app_mysql menuselect.makeopts
./menuselect/menuselect --enable cdr_mysql menuselect.makeopts
make
./contrib/scripts/get_mp3_source.sh
make install
# make samples
make config
service asterisk start
service asterisk status
 
# error: Unable to connect to remote asterisk (does /var/run/asterisk/asterisk.ctl exist?)
# si obtienes este error se debe deshabilitar selinux usando la siguiente linea: 
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
 
# desactivar firewalld (si es necesario)
systemctl stop firewalld
systemctl disable firewalld
 
# instalacion web server
yum -y install httpd
systemctl enable httpd
systemctl start httpd
 
#instalacion php y modulos especificos
yum -y install php php-common php-cli php-dom php-mysqlnd php-posix php-soap libzip
 
# servidor db mysql y configuracion 
yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server
systemctl start mysqld
systemctl enable mysqld
mysql -u root
    use mysql;
    UPDATE user SET password=PASSWORD("123456") WHERE user='root';
    FLUSH PRIVILEGES;
    QUIT;

