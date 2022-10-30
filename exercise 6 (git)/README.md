## WEEK 5
# Git
Git is a version control tool. Version control is the practice of saving snapshots of your development progress so that you can revisit the state of your code at any point in time using these snapshots. There are different tools for version control but the most popular is git.

For a beginner the basic lifecycle of git is implemented by the following commands:
- `git init`: This initializes git in your project
- `git add`: This is used to add files or directories in your project which you wish to track to git.
- `git commit`: This command is used to stage modified documents. It basically allows git to accept changes made to files.
- `git push`: This copies our local project on our system to a remote repository on a server somewhere or in the cloud. It provides a backup of our project should something happen to our local machine.

Remote repositories are provisioned by a lot of platform as a service (PaaS) like GitHub, GitLab, BitBucket etc.

<br>

---

<br>

## Exercise 6

**Task:**

You already have Github account, aso setup a GitLab account if you don’t have one already
You already have a altschool-cloud-exercises project, clone the project to your local system
Setup your name and email in Git’s global config

**Instruction:**

Submit the output of:
- git config -l
- git remote -v
- git log
