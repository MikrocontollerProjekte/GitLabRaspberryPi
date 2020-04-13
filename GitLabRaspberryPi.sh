# 
#   Installation of GitLab CE on a Raspberry Pi 4 (4GB)
#   - Install GitLab on a Raspberry Pi 4
#   - Configure the GitLab server
#
#   MikrocontrollerProjekte 2020
#   https://www.youtube.com/c/MikrocontrollerProjekte
#
#   Visite my GitHub page to download this file:	
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



