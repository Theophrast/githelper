# Gitinit

Gitinit.sh is a simple script to initialize a new git repo on your git server.


### Installation

Download gitinit.sh script to your server:
```sh
$ wget https://raw.githubusercontent.com/Theophrast/gitinit/master/script/gitinit.sh
```
Customize your script, open with nano, change parameters, save it with Ctrl+O
```sh
$ nano gitinit.sh
```
After customization make executable:
```sh
$ sudo chmod +x gitinit.sh
```
Move to /usr/bin/ folder to make accessible for everyone
```sh
$ sudo mv gitinit.sh /usr/bin/gitinit.sh
```
Thats it!
You can access this script anywhere:
```sh
$ gitinit.sh
```
#### Parameters:
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