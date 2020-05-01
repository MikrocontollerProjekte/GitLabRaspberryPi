# 
#   Installation of GitLab CE on a Raspberry Pi 4 (4GB)
#   - Install GitLab on a Raspberry Pi 4
#   - Configure the GitLab server
#
#   MikrocontrollerProjekte 2020
#   https://www.youtube.com/watch?v=VVp0buV-wVM
#
#   Visit my GitHub page to download this file:	
#   https://github.com/MikrocontollerProjekte/GitLabRaspberryPi/GitLabRaspberryPi.sh
#


################## update your system (OPTIONAL STEP) ################## 

# update your systems package list
sudo apt update

# upgrade all your installed packages to their latest versions
sudo apt upgrade



################## change hostname and password (OPTIONAL STEP) ################## 

# show current hostname
hostname

# open Raspberry Pi configuration tool, change hostname and default user password, enable SSH
sudo raspi-config

# restart Raspberry Pi
sudo reboot

# check hostname
hostname



##################  mount USB Stick (RECOMMENDED STEP) ##################

# creates a directory for the USB Stick
sudo mkdir /media/usbstick

# change owner
sudo chown pi /media/usbstick

# show devices
sudo fdisk -l

# format the usb stick in EXT4 
sudo mkfs.ext4 /dev/sda1 

# mount the USB stick
sudo mount /dev/sda1 /media/usbstick

# get the USB stick UUID (Universally Unique Identifier)
sudo blkid

# edit fstab
sudo nano /etc/fstab

	# add automount USB stick on startup 
	UUID=a322538a-2390-4d4f-b13a-7f057b4f2117  /media/usbstick  ext4  defaults  0  0



################## increase STACK size (RECOMMENDED STEP) ##################

# show RAM and STACK usage
free -m

# increase STACK size: CONF_SWAPSIZE=2048
sudo nano /etc/dphys-swapfile

# restart STACK 
sudo /etc/init.d/dphys-swapfile restart

# check available STACK
free -m



################## install GitLab (NECESSARY STEP) ##################

# download the latest package of GitLab CE from https://packages.gitlab.com/gitlab/raspberry-pi2
curl -Lo gitlab-ce_12.6.2-ce.0_armhf.deb https://packages.gitlab.com/gitlab/raspberry-pi2/packages/raspbian/stretch/gitlab-ce_12.6.2-ce.0_armhf.deb/download.deb

# install the downloaded package
sudo apt install ./gitlab-ce_12.6.2-ce.0_armhf.deb

# modify gitlab.rb configuration
sudo nano /etc/gitlab/gitlab.rb

	# change external_url to the IP of your Raspberry Pi
	external_url 'http://192.168.178.35'

	# reduce the number of running workers to the minimum in order to reduce memory usage (line 750)
	unicorn['worker_processes'] = 2

	# tune the amount of concurrency in your Sidekiq process (line 814)
	sidekiq['concurrency'] = 9

	# storing GitLab data in an alternative directory (line 438)
	git_data_dirs({ "default" => { "path" => "/media/usbstick/git-data" } })

# reconfigure GitLab
sudo gitlab-ctl reconfigure

# visite http://gitlab/ with your Browser
http://gitlab/



################## check if GitLab is running after reboot (OPTIONAL STEP) ##################

# get GitLab service status
sudo gitlab-ctl status

# stop all GitLab components
sudo gitlab-ctl stop

# restart Raspberry Pi
sudo reboot






#-------------------------------------------------------------------------------------------------------------------


#
#   Usage of GitLab
#   - Generate a SSH key pair for authentication
#   - Create and push a project to your GitLab server
#   - Clone a project from your GitLab server
#   - Issues and merge requests example
#
#   MikrocontrollerProjekte 2020
#   https://www.youtube.com/c/MikrocontrollerProjekte
#
#   Visit my GitHub page to download this file:	
#   https://github.com/MikrocontollerProjekte/GitLabRaspberryPi
#
#   system requirements:
#   - install Git (free and open source distributed version control system):  https://git-scm.com/
#


################## SSH Key (RECOMMENDED STEP) ##################

# create an SSH Key for your server (press enter to don't use a keyphrase)
ssh-keygen -t rsa -b 4096 -C "JohnDoe@gmail.com"

#  ensure that ssh-agent is enabled by running
eval $(ssh-agent -s)

# add your private key to the SSH registry 
ssh-add ~/.ssh/id_rsa

# go to SSH directory
cd ~/.ssh/

# create the config file
touch config



################## push a (STM32CubeIDE) project to your GitLab server ##################

# create a new project in GitLab (new project button or plus icon in the navigation bar) http://gitlab/

# copy the SSH repository URL from the GitLab project (Clone button --> Clone with SSH --> Copy URL to clipboard)

# initialize the local STM32CubeIDE project folder as an empty Git repository
git init

# add the copied SSH repository URL as remote repository where your local repository will be pushed to
git remote add origin git@192.168.178.35:root/stm32f7_motorctrl.git

# verify the new remote SSH repository URL
git remote -v

# add all files to your local repository staging area
git add .

# commit all files that you have staged in your local repository
git commit -m "first commit - initial project"

# push the changes in your local repository to GitLab
git push origin master



################## clone a (STM32CubeIDE) project from your GitLab server ##################

# copy the SSH repository URL from the GitLab project (Clone button --> Clone with SSH --> Copy URL to clipboard)

# clone the project repository into your local STM32CubeIDE workspace
git clone git@gitlab:stm32f7_motorctrl.git

# import the project into STM32CubeIDE workspace



################## push a development branch to your GitLab server and merge it into master branch in GitLab ##################

# create the development branch "dev_startup_delay"
git branch dev_startup_delay

# switch to the development branch 
git checkout dev_startup_delay

# show the working tree status
git status

#  add the changed main.c file to your local repository staging area
git add Core/Scr/main.c

# check the working tree status
git status

# commit changes that you have staged in your local repository
git commit -m "add a startup delay"

# push the development branch in your local repository to GitLab
git push origin dev_startup_delay

# merge the development branch into master branch in GitLab

# switch back to master branch 
git checkout master

# pull new master to local repository
git pull origin master



