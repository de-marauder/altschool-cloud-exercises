# LINUX Commands

This article showcases 10 Linux commands and their uses

## 1. sudo: 
Sudo is a command used to grant other users root user privileges in a linux system. It is used because most times it is not advisable to have all users having maximum permissions on a linux system. So, with this command they can temporarily get the permissions they require to perform certain tasks as the root user. 

![sudo](https://user-images.githubusercontent.com/65220956/184995348-8fa435b0-e960-4a00-a85a-b1777147f403.png)

In the above example, I have created a new directory using sudo privileges and as you can see by the `ls -l` command, the folder belongs to the root user because it was created with root user privileges via the sudo command

## 2. apt: 
Apt is linux’s default application manager and is used to install, update, remove and generally manage the applications on a linux system.

![apt](https://user-images.githubusercontent.com/65220956/184997603-fbde0019-60cd-4686-af01-fcd41647dadc.png)

In this example, I update all applications on my machine using the command `sudo apt update`.

## 3. grep: 
This command is used for identifying patterns in files and print to the terminal lines where they occur.

![grep](https://user-images.githubusercontent.com/65220956/184998411-517ab437-18f9-4aa2-92d6-0f4039f58d11.png)

In this example, I have searched the file `answer.md` for the word 'linux' and as you can see the `grep` command has spat unto the screen all lines containing the word 'linux' and painted it red.

## 4. less: 
This command is used to display the contents of a file one full screen at a time. The file opens up as a session on the terminal and must exited after use by hitting the ‘q’ key

![less-1](https://user-images.githubusercontent.com/65220956/184998906-a689ffd7-be23-4c10-beb9-25463eab520b.png)

![less-2](https://user-images.githubusercontent.com/65220956/184998924-662598ac-3e1e-482b-9b61-756fc15aeff2.png)

In this example I used the command `less answer.md` to display all the contents of the `answer.md` file one screen at a time.

## 5. KILL: 
This command is used to stop or kill running processes by sending them selected signals. For example you could send the SIGTERM signal to terminate a process by attaching the option ‘9’ to the KILL command.

![kill-1](https://user-images.githubusercontent.com/65220956/185002045-730c17bd-1424-43ac-b050-db92b87573bc.png)

In this example, I have started up the application 'discord' via the command line.

![kill-2](https://user-images.githubusercontent.com/65220956/185002068-9d3d0ed3-2fd9-4bcb-ad4f-36cb7215d6b2.png)

Then I check for the `PID` (process ID) using the command top. the `PID` is 1853300

![kill-3](https://user-images.githubusercontent.com/65220956/185002087-7f1e420e-b730-43f4-a4ed-2b589fee54e8.png)

I then use the `kill` command with the `-9` option to send a `SIGTERM` signal to the process bearing the `PID` 1853300 (which is discord).

![kill-4](https://user-images.githubusercontent.com/65220956/185002104-d00a98e5-9234-423f-b878-de6c310f3943.png)

On checking `top` again we can see that the process with `PID` of 1853300 has disappeared

![kill-5](https://user-images.githubusercontent.com/65220956/185002121-ae2cb5e9-9b2c-478e-9085-2e1404debcde.png)

also from this screenshot it can be seen that discord has been terminated/killed.


## 6. chown: 
This command is used to change the ownership of a file or directory on a linux system.

![chown](https://user-images.githubusercontent.com/65220956/185003296-bcacea35-5d9b-4c96-bc5d-7086ef11f609.png)

Here, I have changed the owner of the `answer.md` file to the root user and back to the user 'de-marauder' who owned it before. You'll also notice I had to run this command using `sudo` to gain all necessary permissions to change ownership of documents.

## 7. chmod:  
This command is used to change the mod bits of a file or directory on a linux system. These mod bits define the permissions required to perform read, write and execute operations on a file. They are usually of the form `-rwxrw-rw-`. This example means that this file has read, write and execute privileges for the current user, and only read and write privileges for the user groups and all other users. The modbits can be viewed by listing the contents of a directory in long format using the command `ls -l`

![chmod](https://user-images.githubusercontent.com/65220956/185004272-5653f6ca-e3c8-483d-952f-f616c60293ea.png)

In this example, I have set and reset the file permission of the `answer.md` file using the `chmod` command. From the image, it can be seen that file is made executable my the user and then unexecutable again.

## 8. ssh: 
This command is used to access a server remotely and peruse or make changes to it. It requires the username of a user on the server, the IP address of the server and user’s password to successfully enter into the server remotely.



## 9. rmdir: 
This command is used to remove empty directories.

![rmdir](https://user-images.githubusercontent.com/65220956/185005207-6da31d85-3218-43de-87df-c65769d79939.png)

As can be seen from the above image, this command can only be used to delete empty directories. I have verified this by executing the command on an empty directory and a directory containing a file. The later threw an error. The state (content) of the folder was verified using the `ls -la` command to list all contents of the directory whether hidden or unhidden in long format.

## 10. ln: 
This command is used to establish links between files. The links created exist as shortcuts to the original file they were linked to.

![ln-1](https://user-images.githubusercontent.com/65220956/185006240-ea88bc84-34ff-49c4-9137-b1fe25eda1e2.png)

Here I have created a new folder and file called `newfile.txt`. I wrote some content to `newfile.txt` and then created a link to it and name it `linkfile` the `-T` option ensures that `linkfile` is always treated as a normal file. I then opened `linkfile` with nano.

![ln-2](https://user-images.githubusercontent.com/65220956/185006263-dd030c75-5bfb-4dbb-b2ce-343b4ff78096.png)

Notice how `linkfile` displays the content written into `newfile` as though it was originally written into `linkfile`.

![ln-3](https://user-images.githubusercontent.com/65220956/185006280-bbecac6a-1113-476e-a7db-1e647c384681.png)

So far the behaviour of this `linkfile` is similar to that of a copied file. To show that the `ln` command does not copy files, I appended some more 
content to `newfile.txt` and what do you know?

![ln-4](https://user-images.githubusercontent.com/65220956/185006302-7ac059c6-1cf0-4d17-b063-82833dee7c8b.png)

It has appeared in the `linkfile` again. What is happening is that the `linkfile` serves as a shortcut of sorts to `newfile.txt` and so when you open `linkfile` it automatically redirects you to `newfile.txt`.

