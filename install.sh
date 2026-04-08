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
	pkg install -y git-lfs
	git lfs install
	echo "[INFO] Finished git-lfs installation!"
fi

echo
echo

if (which zsh > /dev/null 2>&1); then
	echo "[INFO] zsh already installed, passing."
else
	echo "[INFO] Starting zsh installation!"
	pkg install -y zsh
	echo "[INFO] Setting zsh as the default shell."
	chsh -s zsh
	echo "[INFO] Finished zsh installation!"
fi

echo
echo

if (which starship > /dev/null 2>&1); then
	echo "[INFO] starship already installed, passing."
else
	echo "[INFO] Starting starship installation!"
	pkg install starship
	echo "[INFO] Finished starship installation!"
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
