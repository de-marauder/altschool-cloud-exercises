# How to setup a gmail SMTP client on ubuntu and send mails from the terminal

## Step 1
Install ssmtp and mutt
```sh
sudo apt update
sudo apt install ssmtp && apt install mutt -y
```

## Step 2
Configure ssmtp

- Open the file /etc/ssmtp/ssmtp.conf and set the following configurations
```
UseSTARTTLS=no
FromLineOverride=YES
root=username@gmail.com
mailhub=smtp.gmail.com:465
AuthUser=username@gmail.com
AuthPass=xxxxxxxxxxxxx
rewriteDomain=gmail.com
FromLineOverride=YES
UseTLS=YES
```
NOTE: 
	- The username should match an already existing gmail account. 
	- The account should also have 2 factor authentication enable so that you can generate a password for the `AuthPass` variable. 
	- If port 465 is unavailable, try 587.

## Step 3
Verify your connection using telnet
```sh
telnet smtp.gmail.com 465
```
The result should be as below
--------INSERT IMAGE-------------

## Step 4
Send an email

You could use either of the following methods
```sh
sendmail receiver@gmail.com < /path/to/file
```
or
```sh
mutt -s "E-mail Subject" -- receiver@gmail < /path/to/file
```

## Step 5
Check and verify mail was sent.
