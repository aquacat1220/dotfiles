#!/usr/bin/bash

echo "[INFO] Starting installer!"

echo "[INFO] Making temporary directory ./tmp"
mkdir tmp

if (which curl > /dev/null 2>&1); then
	echo "[INFO] xrdp already installed, passing."
else
	echo "[INFO] Starting xrdp installation!"
	which curl || (echo "[INFO] curl not found, installing." && sudo apt install curl)
	curl -L --output tmp/xrdp-installer.zip https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.4.8.zip
	echo "[INFO] Downloaded xrdp-installer.zip under ./tmp/"
	which unzip || (echo  "[INFO] unzip not found, installing." && sudo apt install unzip)
	unzip tmp/xrdp-installer.zip -d tmp
	echo "[INFO] Unpacked xrdp-installer.zip under ./tmp/"
	chmod +x tmp/xrdp-installer*.sh
	tmp/xrdp-installer*.sh
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
fi

echo
echo

if (which fish > /dev/null 2>&1); then
	echo "[INFO] fish already installed, passing."
else
	echo "[INFO] Starting fish installation!"
	sudo apt-add-repository ppa:fish-shell/release-3
	sudo apt update
	sudo apt install fish
	echo "[INFO] Finished fish installation!"
fi

echo "[INFO] Setting fish as the default shell."
chsh -s $(which fish)

echo
echo

which fc-list || (echo "[INFO] fc-list not found, installing." && sudo apt install fontconfig)
if (fc-list | grep HackNerdFont > /dev/null 2>&1); then
	echo "[INFO] HackNerdFont already installed, passing."
else
	echo "[INFO] Starting HackNerdFont installation!"
	curl -L --output tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
	echo "[INFO] Downloaded Hack.zip under ./tmp/"
	unzip tmp/Hack.zip -d tmp
	echo "[INFO] Unpacked Hack.zip under ./tmp/"
	mv tmp/HackNerdFont-*.ttf ~/.local/share/fonts
	echo "[INFO] Finished loca HackNerdFont installation!"
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
	echo "[INFO] Starting tmux installation!"
	sudo apt install tmux
	echo "[INFO] Finished tmux installation!"
fi

echo
echo

if (ls ~/.tmux/plugins/ | grep tpm > /dev/null 2>&1); then
	echo "[INFO] tpm already installed, passing."
else
	echo "[INFO] Starting tpm installation!"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "[INFO] Finished tpm installation!"
fi

echo
echo

echo "[INFO] Copying dotfiles to $HOME."
echo "[INFO] Previous directory structure is:"
tree -al $HOME
cp --parents -r $(find ( ! -path "./.git" ) -and ( ! -path "./install.sh" ) -and ( ! -path "./README.md" ) .) $HOME
echo "[INFO] Copied dotfiles to $HOME."
echo "[INFO] Modified directory structure is:"
tree -al $HOME

echo "[INFO] Finished installer!"
