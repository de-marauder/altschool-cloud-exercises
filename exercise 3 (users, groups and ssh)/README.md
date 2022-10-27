## WEEK 3
# Users, Groups and Permissions

Just like on windows, Linux systems allow for multiple users to be registered on a single system. Linux excels in the multitasking endeavor allowing multiple users to be logged in at the same time on the same system.  There are two basic types of users:
The root user (The one above all)
Secondary users (ordinary users)

On the linux system, every user has specific permissions i.e. rights to perform certain actions. Files can be owned by specific users. Directories cannot be locked for specific users. Read, write and execute privileges for files can be added or revoked from specific users. These are all permissions that could be set for users on a linux machine.

The root user on any Linux machine is the owner of the system and possesses absolute power to perform any action on the system. For this reason it is advised to not log in as this user as it could result in vulnerabilities if your system is breached by malicious attackers. To remedy this, we create and login as secondary users with limited permissions on the system to prevent direct attacks from the root users account. 

Linux operating systems also incorporate the concept of groups. A group is simply a container with the potential to hold multiple users. The group has specific permissions/rights attached to it and all users in this group automatically inherit these permissions. This allows a system admin to efficiently assign rights to users. For example, in a school, you could have groups for teachers, students, honor students, and administrative staff. When a new user is created, instead of assigning their permissions one by one, the system admin can just create these groups and attach their desired permissions then add users to their respective groups to grant them their permissions/rights.

The root user is created by default when you install your operating system. Another user is also created by you, this is the user you would typically login as. To create other users one must use the `useradd` command. For example, to create a new user called “overlord”, use the following command,
```sh
useradd overlord
```
Once you run this command you can view the created user in the `/etc/passwd` file. You can also give “overlord” a password by using this command,
```sh
passwd overlord
```

Other commands for managing users include:
`usermod`: for modifying users accounts
`userdel`: for deleting users

To create a group, run the following command:
```sh
groupadd <group name>
```
You can then view the group created in the `/etc/group` file.
Other commands for managing groups include:
`groupmod`: for modifying group definitions
`groupdel`: for deleting groups


### SUDO
When performing activities as a normal user, you might occasionally need extra privileges (root user priviledges) to accomplish this, we need to use a nifty command called `sudo` which means “superuser do”. The super user is the root user. So with this command any user that is a sudoer can gain access to the root users rights temporarily. A sudoer is a group which has the rights of a root user. Any user added to this group can be provided permission to utilize the `sudo` command. Use this command like so:
```sh
sudo <command name> <options for command>
```
When a user uses sudo, it requests their password and checks if they are a sudoer before executing the command with root privileges.

To switch between multiple users run the command:
```sh
su <username>
```
To switch to root user you can also run the command:
```sh
su -
```
The `-` represents the root user.

All the commands listed so far have versatile use cases and their various options and descriptions can be viewed in their respective man pages.
