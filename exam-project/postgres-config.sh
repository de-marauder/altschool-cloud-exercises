#!/bin/bash -ex

# This script is for use with the DevOps Challenge of installing PostgreSQL 9.6 on to a provisioned AWS EC2 instance running Ubuntu.

# This script will perform the following steps:
# 1. Set variables such as $packages, $rfolder, $dfolder, $gitloc, $sysuser, $logfile, and $laraveldbscript
# 2. Install packages based off of $packages.
# 3. Create directory: /postgres and other required.
# 4. Create system user 'postgres'.
# 5. Pull PostgreSQL from Git depot and confirm it is correct: git clone git://git.postgresql.org/git/postgresql.git.
# 6. Install PostgreSQL. ensuring the data files are stored in $dataFolder.
# 7. Start the PostgreSQL service using the pg_ctl command.
# 8. Run create_hello.sql script.
# 9. Run '/postgres/bin/psql -c 'select * from hello;' -U user hello_postgres;' against newly created DB and test for succesful response.

# Section 1 - Variable Creation

# echo "Creating variables for use throughout the PSQL installation process"
# $packages is an array containing the dependencies for PostgreSQL
# packages=('git' 'gcc' 'tar' 'gzip' 'libreadline5' 'make' 'zlib1g' 'zlib1g-dev' 'flex' 'bison' 'perl' 'python3' 'tcl' 'gettext' 'odbc-postgresql' 'libreadline6-dev')
packages=('postgresql' 'postgresql-contrib' 'python3-psycopg2')
# $rfolder is the install directory for PostgreSQL
# rfolder='/postgres'
# rfolder="~"
# $dfolder is the root directory for various types of read-only data files
# dfolder='/postgres/data'
# dfolder="~/data"
# $gitloc is the location of the PosgreSQL git repo
# gitloc='git://git.postgresql.org/git/postgresql.git'
# $sysuser is the system user for running PostgreSQL
# sysuser='postgres'
# $laraveldbscript is the sql script for creating the PSQL user and creating a database.
laraveldbscript='/home/postgres/create-laravel-db.sql'
# $logfile is the log file for this installation.
logdir='/var/log/script-install'
logfile=${logdir}'/psqlinstall-log'

mkdir -p $logdir
touch $logfile

# Section 2 - Package Installation

# Ensures the server is up to date before proceeding.
# echo "Updating server..."
sudo apt-get update -y >> $logfile

# This for-loop will pull all packages from the package array and install them using apt-get
# echo "Installing PostgreSQL dependencies"
sudo apt-get install ${packages[@]} -y >> $logfile


# Section 3 - Start postgresql service
sudo systemctl restart postgresql

# echo "Wait for PostgreSQL to finish starting up..."
sleep 5

# The create-laravel-db.sql script is ran to create the user and database.
# echo "Running script"
sudo -u postgres psql -f $laraveldbscript


# # Section 9 - hello_postgres is queried

# echo "Querying the newly created table in the newly created database."
# /postgres/bin/psql -c 'select * from hello;' -U laravel_user hello_postgres;