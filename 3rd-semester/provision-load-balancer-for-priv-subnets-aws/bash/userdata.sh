#!/bin/bash
# sudo su

apt update -y

apt install -y nginx

bash -c 'echo "<h1>This is server $hostname</h1>" > /var/www/html/index.nginx-debian.html'