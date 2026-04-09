#!/usr/bin/bash

echo "[INFO] Starting installer!"

echo
echo

dotfiles_root=$(pwd)

echo "[INFO] Installer will exit on error."
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

if (git lfs > /dev/null 2>&1); then
	echo "[INFO] git-lfs already installed, passing."
else
	echo "[INFO] Starting git-lfs installation!"
	sudo apt-get install -y git-lfs
	git lfs install
	echo "[INFO] Finished git-lfs installation!"
fi

echo
echo

if (which zsh > /dev/null 2>&1); then
	echo "[INFO] zsh already installed, passing."
else
	echo "[INFO] Starting zsh installation!"
	sudo apt-get install -y zsh
	echo "[INFO] Setting zsh as the default shell."
	chsh -s $(which zsh)
	echo "[INFO] Finished zsh installation!"
fi

echo
echo

if (which starship > /dev/null 2>&1); then
	echo "[INFO] starship already installed, passing."
else
	echo "[INFO] Starting starship installation!"
	curl -sS https://starship.rs/install.sh | sh
	echo "[INFO] Finished starship installation!"
fi

echo
echo

if (which code > /dev/null 2>&1); then
	echo "[INFO] code already installed, passing."
else
	echo "[INFO] Starting code installation!"
	sudo apt-get install -y wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
	rm -f packages.microsoft.gpg
	
	sudo apt-get install -y apt-transport-https
	sudo apt update
	sudo apt-get install -y code
	echo "[INFO] Finished code installation!"
fi

echo
echo

cd ..
echo "[INFO] cd-ed out of ./tmp/"

echo
echo

if ([ -e "../was_installed" ]); then
	echo "[INFO] Installer already ran on this machine. Skipping one-time configs."
else
	cd overwrite
	cp -r --parents $(find) $HOME
	cd ..
	if (cd append); then
		cd append
		while read line; do
			cat $line >> $HOME/$line
		done < <(find -type f)
		cd ..
	 fi
	echo "[INFO] Copied dotfiles to $HOME."
fi

echo
echo

rm -rf ./tmp
echo "[INFO] Removed temporary directory ./tmp/"

echo
echo

touch was_installed
echo "[INFO] Remembered we've installed to this machine."

echo
echo

echo "[INFO] Finished installer!"
echo "[INFO] Restart the machine for starship, non-root docker, and nvidia container toolkit to work properly!"
