#!/usr/bin/bash

echo "[INFO] Starting installer!"

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

echo "[INFO] Starting language installation!"
sudo apt-get install -y $(check-language-support -l ko)
echo "[INFO] Finished language installation!"

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

if (which syncthing > /dev/null 2>&1); then
	echo "[INFO] syncthing already installed, passing."
else
	echo "[INFO] Starting syncthing installation!"
  	sudo mkdir -p /etc/apt/keyrings
   	sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    	echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
     	sudo apt-get update
	sudo apt-get install -y syncthing
 	echo "[INFO] Finished syncthing installation!"
fi

echo
echo
 	
if (which xrdp > /dev/null 2>&1); then
	echo "[INFO] xrdp already installed, passing."
else
	echo "[INFO] Starting xrdp installation!"
	curl -L --output ./xrdp-installer.zip https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.4.8.zip
	echo "[INFO] Downloaded xrdp-installer.zip."
 	if (which unzip > /dev/null 2>&1); then
  		echo "[INFO] unzip already installed, passing."
        else
		echo "[INFO] Starting unzip installation!"
		sudo apt-get install -y unzip
		echo "[INFO] Finished unzip installation!"
        fi
	unzip ./xrdp-installer.zip -d .
	echo "[INFO] Unpacked xrdp-installer.zip."
	chmod +x ./xrdp-installer*.sh
	./xrdp-installer*.sh
	echo "[INFO] Finished xrdp installation!"
fi

echo
echo

if (which kitty > /dev/null 2>&1); then
	echo "[INFO] kitty already installed, passing."
else
	echo "[INFO] Starting kitty installation!"
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	echo "[INFO] Finished kitty installation!"
	mkdir -p ~/.local/bin ~/.local/share/applications
 	export PATH=$PATH:~/.local/bin
	# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
	# your system-wide PATH)
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
	# Place the kitty.desktop file somewhere it can be found by the OS
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	# Update the paths to the kitty and its icon in the kitty.desktop file(s)
	sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
	echo "[INFO] Finished kitty desktop integration."
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50
	echo "[INFO] Set kitty as the default terminal."
fi

echo
echo

if (which fish > /dev/null 2>&1); then
	echo "[INFO] fish already installed, passing."
else
	echo "[INFO] Starting fish installation!"
	sudo apt-add-repository ppa:fish-shell/release-3
	sudo apt update
	sudo apt-get install -y fish
	echo "[INFO] Setting fish as the default shell."
	chsh -s $(which fish)
	echo "[INFO] Finished fish installation!"
fi

echo
echo

if (which fc-list > /dev/null 2>&1); then
	echo "[INFO] fc-list already installed, passing."
else
	echo "[INFO] Starting fc-list installation!"
	sudo apt-get install -y fontconfig
	echo "[INFO] Finished fc-list installation!"
fi

echo
echo

if (fc-list | grep HackNerdFont > /dev/null 2>&1); then
	echo "[INFO] HackNerdFont already installed, passing."
else
	echo "[INFO] Starting HackNerdFont installation!"
	curl -L --output ./Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
	echo "[INFO] Downloaded Hack.zip."
	unzip ./Hack.zip -d .
	echo "[INFO] Unpacked Hack.zip."
	mkdir -p ~/.local/share/fonts
	mv ./HackNerdFont-*.ttf ~/.local/share/fonts
	echo "[INFO] Finished local HackNerdFont installation!"
	fc-cache -f
	echo "[INFO] Rebuilt font caches."
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

if (which tmux > /dev/null 2>&1); then
	echo "[INFO] tmux already installed, passing."
else
	echo "[INFO] Skipping tmux."
	# echo "[INFO] Starting tmux installation!"
	# sudo apt-get install -y tmux
	# echo "[INFO] Finished tmux installation!"
fi

echo
echo

if (ls ~/.tmux/plugins/tpm > /dev/null 2>&1); then
	echo "[INFO] tpm already installed, passing."
else
	echo "[INFO] Skipping tpm."
	# echo "[INFO] Starting tpm installation!"
	# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	# echo "[INFO] Finished tpm installation!"
fi

echo
echo

if (which nvim > /dev/null 2>&1); then
	echo "[INFO] nvim already installed, passing."
else
	echo "[INFO] Skipping nvim."
fi

echo
echo

if ([ -e "../was_installed" ]); then
else
fi

echo "[INFO] Disabling mouse acceleration."
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
echo "[INFO] Disabled mouse acceleration."

echo
echo

cd ..
echo "[INFO] cd-ed out of ./tmp/"

echo
echo

if (which tree > /dev/null 2>&1); then
	echo "[INFO] tree already installed, passing."
else
	echo "[INFO] Starting tree installation!"
	sudo apt-get install -y tree
	echo "[INFO] Finished tree installation!"
fi

echo
echo

echo "[INFO] Copying dotfiles to $HOME."
echo "[INFO] Previous directory structure is:"
tree -al $HOME
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
echo "[INFO] Modified directory structure is:"
tree -al $HOME

echo
echo

echo "[INFO] Starting syncthing service."
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

echo
echo

rm -rf ./tmp
echo "[INFO] Removed temporary directory ./tmp/"

echo
echo

touch was_installed

echo "[INFO] Finished installer!"
