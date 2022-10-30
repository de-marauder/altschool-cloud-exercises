# How to deploy a laravel application on a debian 11 server

In this article, I will be detailing how to deloy a laravel application on an aws ec2 instance running a debian OS. The steps however should work on other distros as well. The server configuration will be done using ansible
The project we shall deploy can be found [here](https://github.com/f1amy/laravel-realworld-example-app)

## Prerequisites
To follow along with this tutorial, you will need the following:
- A server or VM running debian or ubuntu
- A host/master computer preferrably running linux
- ansible
- git
- basic system administration skills

# Procedure

Note all these configurations should be done in your server locally or on a cloud provider

## Step 1

Update package repository
```sh
sudo apt update
```

## Step 2

Install server requirements
```sh
sudo apt install git npm apache2
```

## Step 3

Installing php dependencies
```sh
sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
```

## Step 4
Add php repository to package sources and
Import php repository key
```sh
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list

wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -

sudo apt update
```

## Step 5

Install php and php extensions

```sh
sudo apt install php

sudo apt install php-cli php-fpm php-json php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath php-json
```

## Step 6

Install database (mariaDB or mysql or postgresql)

```sh
sudo apt install mariadb-server mariadb-client python3-mysqldb
```

## Step 7

Setup Database
- Reset root password
- Switch to unix socket authentication
- Remove anonymous users
- Allow root user to login remotely
- Remove test database
- Create new database for our app
- Reload privilege tables

```sh
mysql_secure_installation
```

## Step 8

Add apache configuration to sites-available using a text editor of your choice

```sh
vi /etc/apache2/sites-available/<site-name>.conf
```
or
```sh
emacs /etc/apache2/sites-available/<site-name>.conf
```
or
```sh
nano /etc/apache2/sites-available/<site-name>.conf
```
Your conf file should look like this
```
<VirtualHost *:{{ http_port }}>
    ServerAdmin username@localhost
    ServerName {{ site-name }}
    ServerAlias www.{{ site-name }}
    DocumentRoot /var/www/{{ site-name }}/public
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/{{ site-name }}>
          Options -Indexes
          AllowOverride all
          Require all granted
    </Directory>

    <IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl  index.xht>
    </IfModule>

</VirtualHost>
```

## Step 9

- Enable our site
- Disable Apache's default site
- Reload Apache
```sh
/usr/sbin/a2ensite <site-name>
/usr/sbin/a2dissite 000-default.conf

sudo systemctl reload apache2
```

## Step 10

Create our site directory

```sh
mkdir -p /var/www/<site-name>
```

## Step 11

Clone laravel project from github and transfer all its contents to /var/www/<site-name>

```sh
cd /var/www/<site-name>
git clone git@github.com:f1amy/laravel-realworld-example-app.git

cp -R laravel-realworld-example-app/* .
rm -rf /var/www/<site-name>/laravel-realworld-example-app
```

## Step 12

Assign Permissions

```sh
sudo chown -R <server-user>:www-data /var/www/example.com/
find /var/www/<site-name>/ -type f -exec chmod 664 {} \;    
find /var/www/<site-name>/ -type d -exec chmod 775 {} \;
chgrp -R www-data storage bootstrap/cache
chmod -R ug+rwx storage bootstrap/cache
```

## Step 13

Download and run composer. Make sure to reference their docs [here](https://getcomposer.org/download/)

```sh
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

## Step 14

Install project dependencies and run project

```sh
cd /var/www/<site-name>
composer install
npm install
npm run prod
```

## Step 15

Expose routes in application by uncommenting this section of the /var/www/<site-name>/routes/web.php file

<img src="./web.php.png" alt="routes" />

## Step 16

Generate an app key for your application using a site like [this](https://generate-random.org/laravel-key-generator) and add it to a .env file at your root directory

.env
```
APP_KEY=<generated-key>
```
then, run
```sh
cd /var/www/<site-name>
php artisan key:generate
```

## Step 17

Check your server using it's public IP <http://IP-address>

<img src="./home-url.png" alt="home page" />

## Step 18

You could decide to configure your DNS on your machine. For this, open the hosts file and add your preferred domain name. **Note** this wont be accesible on the internet.
```sh

sudo nano /etc/hosts

```
add a line like
```
127.0.0.1  <Your domain>
```
to map localhost to your preferred domain name.

## Step 19

Since we are on an EC2 instance you could curl the domain name you just setup to test it.
```sh
curl <domain name>
```

---

> On a side note, just because I like you at this point. If you ever need to enter mysql console as mysql root user be sure to use sudo or better yet switch to root user.

---


# Automation

To automate this process, you can reference the ansible playbook [here](./deploy-LAMP-playbook.yml)

