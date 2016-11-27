#!/bin/bash

### This script sets up system for kernel development. Currently works only on Debian GNU/Linux 8. ###

# Clear the screen
clear

# Check whether script has been started as a root/sudo.
if [ $EUID -ne 0 ]
then
	printf "You have to run this script as a root/sudo.\n" &&
	exit 1
# Check whether we run on Debian GNU/Linux 8
elif [ $(grep -c "8" /etc/debian_version) -eq 0 ]
then
        printf "\nSorry, this script works only on Debian GNU/Linux 8\n\n"
        exit 1
# Check whether username has been provided to us on the command line.
elif [ $# -eq 0 ]
then
	printf "Usage: $0 <username>\n" &&
	exit 1
else
	OUR_USER=$1
	clear
        printf "\nConfigure system...\n\n"
        sleep 2
fi

# Configure debian repositories
if ! grep contrib /etc/apt/sources.list
then
        sed -i '/^deb/ s/$/ contrib/' /etc/apt/sources.list &&
        printf "\nMain Debian repositories has been configured.\n" &&
	sleep 3
else
        printf "\nMain Debian respositories already configured..\n" &&
	sleep 3
fi

# Install all the necessary software.
apt-get update &&
apt-get install -y vim-nox mutt libncurses5-dev gcc make git exuberant-ctags bc libssl-dev build-essential fakeroot &&
# Configure vim
update-alternatives --set editor /usr/bin/vim.nox &&
printf "filetype plugin indent on\nsyntax on\ncolorscheme koehler\nset number\nset hlsearch\nset title\nset tabstop=8\nset softtabstop=8\nset shiftwidth=8\nset noexpandtab" > /home/$OUR_USER/.vimrc &&

### Get the kernel source
printf "\nPrepare kernel environment...\n";

sleep 3;

# Check whether a directory for our kernel source exists - if not, create it.
if [ ! -d /home/$OUR_USER/dev/git/kernel ]
then
        mkdir -p /home/$OUR_USER/dev/git/kernel
fi

# Check whether a directory with kernel source already exists - if not, get the code.
if [ ! -d /home/$OUR_USER/dev/git/kernel/linux-next ]
then
        cd /home/$OUR_USER/dev/git/kernel &&
	# Clone Linux-Next (bleeding edge) kernel repository.
        git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git &&
	# We are assuming that the user's username and his main group name are the same
	chown -R $OUR_USER:$OUR_USER /home/$OUR_USER/dev &&
	printf "\n\nYour Linux kernel development environment has been configured! :-)\n\n"
else
	printf "\n\nSorry, something went wrong.. :-(\n\n"
fi
