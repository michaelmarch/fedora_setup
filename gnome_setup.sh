#!/bin/bash

gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-seconds true

gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

gsettings set org.gnome.desktop.screensaver picture-options 'stretched'

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

gsettings set org.gnome.desktop.background picture-uri '/home/michael/.local/share/gnome-background-properties/wallpaper.xml'
gsettings set org.gnome.desktop.background picture-uri-dark '/home/michael/.local/share/gnome-background-properties/wallpaper.xml'


gnome_terminal_profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
gnome_terminal_profile=${gnome_terminal_profile:1:-1}

git clone https://github.com/dracula/gnome-terminal gnome-terminal/ && \
cd gnome-terminal && \
sh install.sh -s Dracula -p :$gnome_terminal_profile --skip-dircolors && \
cd .. && \
rm -rf gnome-terminal


themes="$HOME/.themes"

mkdir -p $themes && \
wget https://github.com/dracula/gtk/archive/master.zip -O $themes/dracula-gtk.zip && \
unzip $themes/dracula-gtk.zip -d $themes && \
rm $themes/dracula-gtk.zip -f && \
gsettings set org.gnome.desktop.wm.preferences theme "gtk-master" && \
gsettings set org.gnome.desktop.wm.preferences theme "gtk-master" 
mkdir -p ~/.config/environment.d && \
echo 'GTK_THEME=gtk-master' > ~/.config/environment.d/gtk_theme.conf && \
echo 'Sucess2'


icons="$HOME/.icons"

mkdir -p $icons && \
git clone https://github.com/m4thewz/dracula-icons $icons/dracula-icons && \
gsettings set org.gnome.desktop.interface icon-theme "Dracula"


sudo flatpak override --env=GTK_THEME=gtk-master
