#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  echo "Please do not run this script as root"
  exit
fi

assert_file() {
  if [[ ! -z ${1+x} ]] && [[ $1 ]] && [[ ! -f $1 ]]; then
    echo "File $1 not found."
    exit
  fi
}

execute() {
  if [[ ! -z ${1+x} ]] && [[ $1 ]]; then 
    eval $1 || exit
  else
    echo 'execute() expects 1 non empty argument'
  fi
}

assert_file "starship.toml"
assert_file "gnome_setup.sh"
assert_file "zsh_setup.sh"
assert_file ".zshrc"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
execute "sudo dnf upgrade -y"

flatpak install app/com.github.IsmaelMartinez.teams_for_linux/x86_64/stable -y
flatpak install app/com.discordapp.Discord/x86_64/stable -y
flatpak install flathub org.gnome.Extensions -y


execute "sudo dnf remove virtualbox-guest-additions -y"
execute "sudo dnf install piper htop rclone keepassxc gnome-tweaks neofetch dynamic-wallpaper-editor dconf dconf-editor yt-dlp zsh util-linux-user lsd -y"
execute "sudo dnf module install nodejs:18/development -y"

execute "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code -y


source gnome_setup.sh
source zsh_setup.sh

while true; do
  read -p "Run manual configuration? (y/n) " yn
  
  case $yn in
    [yY] ) break;;
    [nN] ) execute "sudo dnf upgrade -y";
           sudo reboot;;
  esac
done

rclone config

wget 'https://cat.eduroam.org/user/API.php?action=downloadInstaller&lang=pl&id=linux&profile=2558' -O ~/eduroam_wifi_script.py
python ~/eduroam_wifi_script.py
rm ~/eduroam_wifi_script.py
