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
	sudo apt-get update
	
	if (which git > /dev/null 2>&1); then
		echo "[INFO] git already installed, passing."
	else
		echo "[INFO] Starting git installation!"
		sudo apt-get install -y git
		echo "[INFO] Finished git installation!"
	fi

	echo
	echo
	
	echo "[INFO] Creating gpg key. Remember the ID."
	gpg --gen-key
	echo "[INFO] Created gpg key."
	
	echo
	echo

	if (which pass > /dev/null 2>&1); then
		echo "[INFO] pass already installed, passing."
	else
		echo "[INFO] Starting pass installation!"
		sudo apt-get install -y pass
		echo "[INFO] Finished pass installation!"
	fi

	echo "[INFO] Initializing pass."
	read -p "Enter the gpg ID used before: " gpg_id
	pass init $gpg_id
	echo "[INFO] Initialized pass."
	
	echo
	echo
	
	echo "[INFO] Touching git configs for credentials."
	git config --global credential.credentialStore gpg
	echo "[INFO] Touched git configs for credentials."
	
	echo
	echo

	if (which curl > /dev/null 2>&1); then
		echo "[INFO] curl already installed, passing."
	else
		echo "[INFO] Starting curl installation!"
		sudo apt-get install -y curl
		echo "[INFO] Finished curl installation!"
	fi

	echo
	echo
	
	echo "[INFO] Starting gcm installation!"
	curl -L https://aka.ms/gcm/linux-install-source.sh | sh
	git-credential-manager configure
	echo "[INFO] Finished gcm installation and configuration!"
	
	echo
	echo
fi

cd ..
echo "[INFO] cd-ed out of ./tmp/"
rm -rf ./tmp
echo "[INFO] Removed temporary directory ./tmp/"

echo
echo

touch was_bootstrapped
echo "[INFO] Remember we've bootstrapped this machine."

echo
echo

echo "[INFO] Finished bootstrapper!"
