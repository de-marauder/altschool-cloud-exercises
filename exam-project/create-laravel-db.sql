-- Create a new user and database and grant maximum privileges to new user

create role laravel_user with login password 'laravel_user';

create database laravelapp with owner laravel_user;

\c laravelapp

GRANT USAGE ON SCHEMA public TO laravel_user;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO laravel_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO laravel_user;

ALTER DEFAULT PRIVILEGES FOR ROLE myusr IN SCHEMA public
GRANT ALL ON TABLES TO laravel_user;

ALTER DEFAULT PRIVILEGES FOR ROLE myusr IN SCHEMA public
GRANT ALL ON SEQUENCES TO laravel_user;