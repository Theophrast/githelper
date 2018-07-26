# Githelper

Githelper is a simple script to initialize a new git repo on your git server.


### Installation

Download githelper script to your server:
```sh
$ wget https://raw.githubusercontent.com/Theophrast/gitinit/master/script/githelper
```
Customize your script, open with nano, change parameters (see configuration), save it with Ctrl+O
```sh
$ nano githelper
```
After customization make executable:
```sh
$ sudo chmod +x githelper
```
Move to /usr/bin/ folder to make accessible for everyone
```sh
$ sudo mv githelper /usr/bin/githelper
```
Thats it!
You can access this script anywhere.

Check for version:
```sh
$ githelper -v
```
To see help file:
```sh
$ githelper -h
```


#### Initialize a new git repository:
```sh
$ githelper -i
$ githelper --init
```

In the wizard screen you can set the name of the repository, and create a new one.

#### List avaiable git repositories in git root folder:
```sh
$ githelper -l
$ githelper --list
```


#### Configuration:
To list current configuration:
```sh
$ githelper -c
```

Edit these lines in githelper script for customisation.
```sh
#IP address of your git server, use static ip
GIT_SERVER_IP_ADDRESS='192.168.0.128'

#your git repo base url, this will contain subfolders
GIT_REPO_BASE_DIRECTORY='/home/git/git-root'

#your git repsitories info will be written in this file
GIT_REPOS_INFO_FILE='/home/git/GIT_REPOSITORIES_INFO.txt'

#default subfolder, if you choose private there will be
# a folder with your name
GIT_REPO_DEFAULT_SUBFOLDER='shared'
```