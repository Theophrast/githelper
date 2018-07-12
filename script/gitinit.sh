#!/bin/bash

########################################################
#
#                     Git initializer
#                        gitinit.sh
#
#       automaticatically initialize a new git repo
#         in a git root folder with a given name
#
#                       Theophrast
#                       2018.07.12
#
#  If you want to run this script from everywhere,
#  make it runnable then you can move or copy it to
#  /usr/bin folder.
#
#                   For more info visit:
#         https://github.com/Theophrast/gitinit
#
##########################################################

#IP address of your git server, use static ip
GIT_SERVER_IP_ADDRESS='192.168.0.128'

#your git repositories base url, this will contain subfolders
GIT_REPO_BASE_DIRECTORY='/home/git/git-root'

#your git repositories info will be written in this file
GIT_REPOS_INFO_FILE='/home/git/GIT_REPOSITORIES_INFO.txt'

#default subfolder, if you choose private there will be
# a folder with your name
GIT_REPO_DEFAULT_SUBFOLDER='shared'


git_subfolder=$GIT_REPO_DEFAULT_SUBFOLDER


findcpu(){
	grep 'model name' /proc/cpuinfo  | uniq | awk -F':' '{ print $2}'
}

findkernelversion(){
	uname -mrs
}

totalmem(){
	grep -i 'memtotal' /proc/meminfo | awk -F':' '{ print $2}'
}

storagestat(){
	git_device=$( df $GIT_REPO_BASE_DIRECTORY | awk '/^\/dev/ {print $1}' )
	df -h | grep $git_device
}

ask_for_repo_name(){
	echo 'What will be the name of the git repository? (without .git extension)'
	read gitreponame

	if [[ -z "$gitreponame" ]]; then
	   printf '%s\n' "Enter a valid name"
	   ask_for_repo_name
	fi
	echo
}

ask_private_repo(){
	echo ''
	read -r -p 'Is it a private repo? [y/N]' response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		git_subfolder=$USER
	fi
}

check_for_git(){
	if ! type "git" > /dev/null; then
	  echo ''
	  echo 'git command not found'
	  echo 'Please install git before use this script to init'
	  echo '       sudo apt-get install git'
	  echo ''
	  exit 1
	fi
}


check_for_exist(){
	if [ -d "$created_repo_url" ]; then
	  echo 'Repository already exist!!!'
	  echo 'Change your repository name or delete existing repository manually.'
	  exit 1
	fi
}


confirm_repo_name(){
	read -r -p 'Initializing a new repo with name: '$gitreponame'.git ? [y/N]' response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
    	echo 'Init repository...'
	else
    	clear
		main
	fi
}

check_for_access_repo_and_create(){
	if [ ! -d "$GIT_REPO_BASE_DIRECTORY" ]; then
		echo 'First start...'
		echo 'Trying to create directory: ' $GIT_REPO_BASE_DIRECTORY
		
		if mkdir -p $GIT_REPO_BASE_DIRECTORY ; then
     	 	
			echo'Directory created succesfully'
			echo''
  		 else
			echo''
      		echo 'Cannot access to git root directory  '$GIT_REPO_BASE_DIRECTORY
      		echo 'Do you have permission to write this folder?'
      		exit 1
   		fi
	
	fi
}

write_infos_on_start(){
  echo '----------------------------------------------------------------------'
	echo
	echo '                    Git initalizer               '
	echo
	echo
	echo "    CPU Type : $(findcpu)"
	echo "    Kernel version : $(findkernelversion)"
	echo "    Total memory : $(totalmem)"
	echo "    Storage status: $(storagestat)"
	echo
	echo "    Git directory root url: "
	echo "    $GIT_REPO_BASE_DIRECTORY/"
	echo
	echo '----------------------------------------------------------------------'
	echo
}



main(){

check_for_git

	if (( $EUID == 0 )); then
			echo "Do not run this script as root!!!"
			echo "If you cannot acces to git base directory, make it writeable"
			echo "     chmod 777 -R <directory>"
			echo ""
			exit 1
		fi
	clear
	
	check_for_access_repo_and_create
   write_infos_on_start
   ask_for_repo_name
   confirm_repo_name
   ask_private_repo
	created_repo_url=$GIT_REPO_BASE_DIRECTORY'/'$git_subfolder'/'$gitreponame'.git'
	
	check_for_exist
	
   echo
   echo 'Creating directory ' $created_repo_url
   
   if mkdir -p $created_repo_url ; then
      echo 'Directory created'
   else
      echo 'Cannot create directory  '$created_repo_url
      echo 'Do you have permission to write this folder?'
      exit 1
   fi
   
   echo
   echo 'Init repository'
   cd $created_repo_url
   git init --bare

   echo 'New repository succesfully created'
   echo
   echo '-----'
   echo
   echo 'Remote address:'
   echo
   echo '   '$USER'@'$GIT_SERVER_IP_ADDRESS':'$created_repo_url
   echo
   echo '-----'
   echo
   echo 'To init on your client:'
   echo
   echo '     git init'
   echo '     echo "message" >> README.md'
   echo '     git add README.md'
   echo '     git commit -m "initial commit"'
   echo '     git remote add origin '$USER'@'$GIT_SERVER_IP_ADDRESS':'$created_repo_url
   echo '     git push -u origin master'
   echo
	echo '----------------------------------------------------------------------'
	
	log_repo_data_to_log_file
	exit 0
}

write_header_to_file(){
	echo "##################################################" >> $GIT_REPOS_INFO_FILE
	echo "#                                                #" >> $GIT_REPOS_INFO_FILE
	echo "#               GIT REPOSITORIES                 #" >> $GIT_REPOS_INFO_FILE
	echo "#                                                #" >> $GIT_REPOS_INFO_FILE
	echo "#         initiated by gitinit script            #" >> $GIT_REPOS_INFO_FILE
	echo "#                                                #" >> $GIT_REPOS_INFO_FILE
	echo "#                                                #" >> $GIT_REPOS_INFO_FILE
	echo "##################################################" >> $GIT_REPOS_INFO_FILE
	
	echo "" >> $GIT_REPOS_INFO_FILE
	echo "" >> $GIT_REPOS_INFO_FILE
	echo "--------------------------------------------------" >> $GIT_REPOS_INFO_FILE
}


log_repo_data_to_log_file(){
if [ ! -f "$GIT_REPOS_INFO_FILE" ]
then
	write_header_to_file
fi


	DATE=`date '+%Y-%m-%d %H:%M:%S'`
	echo "" >> $GIT_REPOS_INFO_FILE
	echo "  "$gitreponame".git">> $GIT_REPOS_INFO_FILE
	echo "" >> $GIT_REPOS_INFO_FILE
	echo "    created on: "$DATE  >> $GIT_REPOS_INFO_FILE
	echo "    created by: "$USER >> $GIT_REPOS_INFO_FILE
	echo "" >> $GIT_REPOS_INFO_FILE
	echo '    Remote address:'>> $GIT_REPOS_INFO_FILE
	echo "" >> $GIT_REPOS_INFO_FILE
	echo '    '$USER'@'$GIT_SERVER_IP_ADDRESS':'$created_repo_url>> $GIT_REPOS_INFO_FILE
	echo "" >> $GIT_REPOS_INFO_FILE
	echo "--------------------------------------------------" >> $GIT_REPOS_INFO_FILE
}


main

