## WEEK 4

# Process Management

Every task or piece of software being executed by a  linux machine is referred to as a process and this is not unlike the case in other operating systems. Sometimes it may be necessary for us to examine our system and find out what processes are running and how much memory they are hugging. This week I learnt how to do this and I will be sharing it with you as well. 

In the linux operating system, most of the tasks are performed via a terminal and when a process is running in the terminal, it must finish executing or be terminated before another process can be started. Since this is the case, Linux allows us to send running processes to the background so we can perform other tasks via the same terminal. This allows us to have 2 sets of processes:
- Background processes and 
- Foreground processes

To run a process in the background you just need to append an ampersand symbol (&) at the end of your command like so:
```sh
ping google.com &
```
Or run the command like so
```sh
ping google.com
```
Stop it by pressing `ctrl + z` then run `bg`. This sends the stopped process to the background.

To view active processes running in the background, run the command
```sh
jobs
```
To bring background processes back to the foreground run
```sh
fg <job number>
```
The job number is the first number on every line when you run the `jobs` command.

Types of Processes
There are basically 5 types of processes:
1. Parent processes
2. Child processes
3. Orphaned processes
4. Zombie processes
5. Daemon processes

Parent processes are processes that initiate other processes. For example, when you run a command in the terminal, the command is accepted by the `shell` (which is a process) and the shell then initiates another process based on the command passed to it. This makes the `shell` a parent process.

__Child processes__ are processes which have been initiated by another process. So technically every process is a child process at some point. 

__Orphaned processes__ are processes which have lost their parent processes i.e. Their parent processes have been terminated or shut down for some reason.

__Zombie processes__ are processes which have been terminated or have finished executing but still show up as running processes.

__Daemon processes__ are processes that control system functionality behind the scenes. They are all background processes that enable the functionality of other processes to run. These processes are typically just called “daemons”. An example of a daemon is `systemd` the master daemon. This is the first process to be executed on a linux machine and can be used to control or manage all other daemons running on the system.


Some commands used to manage processes include:
- `ps`: This is the process command. It can be used to view all process running and their relationships to one another depending on the options passed to it. Frequently, you might find it being used in this manner: 
```sh
ps aux
```
This displays all processes for all users. The man page provides more details about how this command can be used

- `kill`: As the name implies, this command is used to kill processes. Depending on the options passed, this command could do anything from pausing a process to forcefully ending it. Usage:
```sh
kill <option> <PID>
```
The PID is the process id of a process. It can be obtained from the `ps` or `top` commands.

- `top`: This command displays all running processes in order of CPU usage. It is activated by simply running `top` in the terminal. It shows the process ids (PID), CPU usage, niceness value (NI), Virtual memory being used (VIRT), start time of process (TIME+) and the command that initaited the process amongst other things.

Other commands include: 
- `nice`: sets priority for a new process
- `renice`: resets priority of an existing process
- `df`: Displays hard disk usage
- `free`: displays RAM usage
