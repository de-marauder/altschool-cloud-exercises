#!/bin/bash
sudo timedatectl set-timezone Africa/Lagos

export t="$(date) $(timedatectl | head -4 | tail -1 | awk -F ': ' '{print $2}')"

echo "<h1>$(hostname)</h1>" >/var/www/html/index.html
echo "<h2>$t</h2>" >>/var/www/html/index.html
