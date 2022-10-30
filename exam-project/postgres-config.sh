#!/bin/bash -ex

# This script is for installing the latest version of PostgreSQL on to a provisioned AWS EC2 instance running Debian.

# This script will perform the following steps:
# 1. Set variables such as $packages, $logdir, $logfile, and $laraveldbscript
# 2. Install packages based off of $packages.
# 3. Start the PostgreSQL service using the systemctl command.
# 4. Run create-laravel-db.sql.sql script.

# Section 1 - Variable Creation

# $packages is an array containing the dependencies for PostgreSQL
packages=('postgresql' 'postgresql-contrib' 'python3-psycopg2')
# $laraveldbscript is the sql script for creating the PSQL user and creating a database.
laraveldbscript='/home/postgres/create-laravel-db.sql'
# $logdir is the log file directory for this installation.
logdir='/var/log/script-install'
# $logfile is the log file for this installation.
logfile=${logdir}'/psqlinstall-log'

mkdir -p $logdir
touch $logfile

# Section 2 - Package Installation

# Ensures the server is up to date before proceeding.
# echo "Updating server..."
sudo apt-get update -y >> $logfile

# This for-loop will pull all packages from the package array and install them using apt-get

sudo apt-get install ${packages[@]} -y >> $logfile


# Section 3 - Start postgresql service

sudo systemctl restart postgresql

# "Wait for PostgreSQL to finish starting up..."
sleep 5

# Section 4

# The create-laravel-db.sql script is ran to create the user and database.

sudo -u postgres psql -f $laraveldbscript

