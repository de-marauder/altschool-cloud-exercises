sudo su

apt update -y

apt install -y nginx

echo "<h1>$hostname</h1>" > /var/www/html/index.nginx-debian.html