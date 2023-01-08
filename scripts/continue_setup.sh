#!/bin/bash

gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable clipboard-history@alexsaveau.dev
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable just-perfection-desktop@just-perfection
gnome-extensions enable sound-output-device-chooser@kgshank.net

gnome-extensions disable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable arcmenu@arcmenu.com
gnome-extensions disable auto-move-windows@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable background-logo@fedorahosted.org
gnome-extensions disable caffeine@patapon.info
gnome-extensions disable dash-to-panel@jderose9.github.com
gnome-extensions disable ding@rastersoft.com
gnome-extensions disable freon@UshakovVasilii_Github.yahoo.com
gnome-extensions disable gestureImprovements@gestures
gnome-extensions disable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable openweather-extension@jenslody.de
gnome-extensions disable places-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable pop-shell@system76.com
gnome-extensions disable supergfxctl-gex@asus-linux.org
gnome-extensions disable volume-mixer@evermiss.net
gnome-extensions disable window-list@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable wireless-hid@chlumskyvaclav.gmail.com

dconf write /org/gnome/shell/extensions/appindicator/tray-pos "'right'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size "48"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'DYNAMIC'"
dconf write /org/gnome/shell/extensions/dash-to-dock/disable-overview-on-startup "false"
dconf write /org/gnome/shell/extensions/just-perfection/activities-button "false"
dconf write /org/gnome/shell/extensions/just-perfection/background-menu "false"
dconf write /org/gnome/shell/extensions/just-perfection/show-apps-button "false"
dconf write /org/gnome/shell/extensions/just-perfection/startup-status "0"
dconf write "/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-custom-command" "true"
dconf write "/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/custom-command" "'/bin/zsh'"


gsettings set org.gnome.desktop.interface.clock-show-weekday true
gsettings set org.gnome.desktop.interface.clock-show-seconds true
gsettings set org.gnome.desktop.session.idle-delay 0
gsettings set org.gnome.desktop.peripherals.mouse.speed -0.47
gsettings set org.gnome.desktop.media-handling.autorun-x-content-open-folder []
gsettings set org.gnome.desktop.media-handling.autorun-x-content-ignore []
cp wallpaper.jpg $HOME/.config/
gsettings set org.gnome.desktop.background picture-uri file://$HOME/.config/wallpaper.jpg
gsettings set org.gnome.desktop.background picture-uri-dark file://$HOME/.config/wallpaper.jpg

rm $HOME/.config/autostart/org.gnome.Terminal.desktop
rm $HOME/.local/bin/continue_setup.sh

sudo dnf update -y
sudo dnf autoremove -y

echo "The system will reboot in 5 seconds..."
sleep 5
sudo reboot
