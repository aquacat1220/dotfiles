#!/usr/bin/bash

echo "[INFO] Starting bootstrapper!"

echo
echo

dotfiles_root=$(pwd)

echo "[INFO] Bootstrapper will exit on error."
handle_error() {
	echo "[ERR] An error occurred on line $1."
	rm -rf $dotfiles_root/tmp
	exit 1
}
trap 'handle_error $LINENO' ERR

echo
echo

echo "[INFO] Making temporary directory ./tmp/"
mkdir tmp
echo "[INFO] cd-ing into ./tmp/"
cd tmp

echo
echo

if ([ -e "../was_bootstrapped" ]); then
	echo "[INFO] Bootstrapper already ran on this machine."
else
	pkg update
	
	if (which git > /dev/null 2>&1); then
		echo "[INFO] git already installed, passing."
	else
		echo "[INFO] Starting git installation!"
		pkg install -y git
		echo "[INFO] Finished git installation!"
	fi

	echo
	echo

	if (which ssh-keygen > /dev/null 2>&1); then
		echo "[INFO] ssh-keygen already installed, passing."
	else
		echo "[INFO] Starting ssh-keygen installation!"
		pkg install -y openssh
		echo "[INFO] Finished ssh-keygen installation!"
	fi

	echo
	echo

	echo "[INFO] Starting ssh key generation!"
	echo "[ACTION] Remember where you store the generated key."
	ssh-keygen
	read -p "[ACTION] Enter path to generated key (defaults to ~/.ssh/id_ed25519 if left blank): " key_path
	if [ -z "$key_path" ]; then
		key_path="~/.ssh/id_ed25519"
	fi
	ssh-add $key_path
	echo "[INFO] Added key to ssh-agent."
	echo "[ACTION] Copy the following content to https://github.com/settings/ssh/new to register the key."
	cat "$key_path.pub"
	read -p "[ACTION] Press Enter when ready."
	echo "[INFO] Finished ssh key generation and registration!"

	echo
	echo

	if (which curl > /dev/null 2>&1); then
		echo "[INFO] curl already installed, passing."
	else
		echo "[INFO] Starting curl installation!"
		pkg install -y curl
		echo "[INFO] Finished curl installation!"
	fi
 
	echo
	echo
fi

cd ..
echo "[INFO] cd-ed out of ./tmp/"
rm -rf ./tmp
echo "[INFO] Removed temporary directory ./tmp/"

echo
echo

echo "[INFO] cd-ing into ~."
cd ~

echo
echo

if ([ -d "dotfiles" ]); then
	echo "[INFO] dotfiles repo is already cloned, and this run is likely occuring inside it."
else
	echo "[INFO] Clone this repo to ~."
	git clone -b termux git://github.com/aquacat1220/dotfiles.git
fi

echo
echo

echo "[INFO] cd-ing into ~/dotfiles/"
cd dotfiles

echo
echo

touch was_bootstrapped
echo "[INFO] Remembered we've bootstrapped this machine."

echo
echo

echo "[INFO] Finished bootstrapper!"
