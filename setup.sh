#!/bin/bash

source ./scripts/utils.sh

if [[ $EUID -eq 0 ]]; then
    echo "Please do not run this script as root."
    exit $ERROR_ROOT_USER_DETECTED
fi

exit -1

GPU=$(lspci -nnk | grep -Ei "3d|vga")
if echo "$GPU" | grep -Eqi "amd|ati"; then
    if assert_file "scripts/amd_setup.sh"; then
        source ./scripts/amd_setup.sh
    else
        echo "Aborting..."
        exit $ERROR_FILE_NOT_FOUND
    fi
elif echo "$GPU" | grep -Eqi "nvidia"; then
    if assert_file "scripts/nvidia_setup.sh"; then
        source ./scripts/nvidia_setup.sh
    else
        echo "Aborting..."
        exit $ERROR_FILE_NOT_FOUND
    fi
else
    echo "Unsupported GPU, Aborting..."
    exit $ERROR_UNSUPPORTED_GPU_DETECTED
fi

start_section "Configure dnf and run updates" \
    "cat /etc/dnf/dnf.conf | grep -Pq 'fastestmirror=' || sudo sh -c 'echo 'fastestmirror=True' >> /etc/dnf/dnf.conf'" \
    "cat /etc/dnf/dnf.conf | grep -Pq 'max_parallel_downloads=\d+' || sudo sh -c 'echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf'" \
    "sudo dnf update -y"

start_section "Add thirdparty repos and run updates (again)" \
    "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc" \
    "sudo sh -c 'echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" > /etc/yum.repos.d/vscode.repo'" \
    "sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y" \
    "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" \
    "sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/" \
    "sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc" \
    "dnf check-update -y" \
    "sudo dnf update -y" \
    "sudo dnf groupupdate core -y" \
    "sudo dnf groupupdate multimedia --setop=\"install_weak_deps=False\" --exclude=\"PackageKit-gstreamer-plugin\" -y" \
    "sudo dnf groupupdate sound-and-video -y"

# TODO: replace neofetch with fastfetch ???
start_section "Install software" \
    "sudo dnf install -y \
        $packages \
        https://extras.getpagespeed.com/release-latest.rpm \
        blender \
        brave-browser \
        code \
        corectrl \
        dconf \
        dconf-editor \
        deluge \
        dnf-plugins-core \
        dynamic-wallpaper-editor \
        gamemode \
        gimp \
        gnome-tweaks \
        htop \
        inkscape \
        java-17-openjdk-devel \
        java-17-openjdk-javadoc \
        kdenlive \
        keepassxc \
        krita \
        lm_sensors \
        lsd \
        lutris \
        neofetch \
        nextcloud-client \
        obs-studio \
        onlyoffice-desktopeditors \
        papirus-icon-theme \
        piper \
        shotcut \
        solaar \
        stacer \
        steam \
        steamtinkerlaunch \
        streamlink \
        util-linux-user \
        vkBasalt \
        vlc \
        wine \
        winetricks \
        yt-dlp \
        zsh" \
    "flatpak install flathub com.mattjakeman.ExtensionManager -y" \
    "download_latest_rpm https://github.com/TheAssassin/AppImageLauncher/ appimage-launcher.rpm 64.rpm" \
    "mkdir -p $HOME/Applications/ && download_latest https://github.com/streamlink/streamlink-twitch-gui/ $HOME/Applications/TwitchGui.AppImage AppImage" \
    "download_latest_rpm https://github.com/SpacingBat3/WebCord/ webcord.rpm x86_64.rpm" \
    "download_latest_rpm https://github.com/ferdium/ferdium-app/ ferdium.rpm rpm" \
    "download_latest_rpm https://github.com/Kong/insomnia/ insomnia.rpm rpm" \
    "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash"

#TODO: remove CGNS apps from view
start_section "Clear iptables rules" \
    "sudo iptables -F && \
        sudo ip6tables -F"

firewalld_version=$(sudo dnf info firewalld | grep 'Version' | tr -s " " | cut -d " " -f3)

# https://github.com/firewalld/firewalld/issues/1055
start_section "Apply wow fix for VoiceError: 17" \
    "assert_file \"services/wowfix.service\" && \
        assert_file \"scripts/wowfix.sh\" && \
        compare_versions 1.2.3 $firewalld_version || \
        sudo cp services/wowfix.service /etc/systemd/system/ && \
        chmod 755 scripts/wowfix.sh && \
        sudo cp scripts/wowfix.sh /usr/local/sbin/ && \
        sudo systemctl enable wowfix.service"

start_section "Configure Gnome's look" \
    "gsettings set org.gnome.desktop.interface.clock-show-weekday true" \
    "gsettings set org.gnome.desktop.interface.clock-show-seconds true" \
    "gsettings set org.gnome.desktop.session.idle-delay 0" \
    "gsettings set org.gnome.desktop.peripherals.mouse.speed -0.47" \
    "gsettings set org.gnome.desktop.media-handling.autorun-x-content-open-folder []" \
    "gsettings set org.gnome.desktop.media-handling.autorun-x-content-ignore []" \
    "cp wallpaper.jpg $HOME/.config/" \
    "gsettings set org.gnome.desktop.background picture-uri file://$HOME/.config/wallpaper.jpg" \
    "gsettings set org.gnome.desktop.background picture-uri-dark file://$HOME/.config/wallpaper.jpg" \
    "download_latest https://github.com/ryanoasis/nerd-fonts/ $HOME/Applications/FiraCode.zip FiraCode.zip" \
    "unzip -q $HOME/.fonts/firacode/firacode.zip -d $HOME/.fonts/firacode/ && \
        find $HOME/.fonts/firacode/ -type f ! \( -name '*Complete.ttf' -o -name '*Mono.ttf' \) -delete && \
        fc-cache -f -v"

# TODO: enable this extension after reboot
start_section "Install Gnome extensions" \
    "git clone https://github.com/michaelmarch/temperature-monitor $HOME/.local/share/gnome-shell/extensions/"

start_section "Misc configuration" \
    "sudo sensors-detect --auto" \
    "cp $HOME/usb/fedora-setup/configs/disable-usb-wake.conf /etc/tmpfiles.d/"

start_section "Shell configuration" \
    "cp .zshrc $HOME/.zshrc" \
    "dconf write \"/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-custom-command\" \"true\"" \
    "dconf write \"/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/custom-command\" \"'/bin/zsh'\"" \
    "mkdir -p $HOME/.config/starship/ && \
        cp configs/starship.toml $HOME/.config/starship/ \
        curl -sS https://starship.rs/install.sh | sh -s -- -y"

start_section "Platform specific configuration"
setup

start_section "Prepare stage 2 setup" \
    "cp scripts/continue_setup.sh $HOME/.local/bin/ && \
        chmod +x $HOME/.local/bin/continue_setup.sh && \
        cp /usr/share/applications/org.gnome.Terminal.desktop ~/.config/autostart && \
        sed -i \"s+^Exec=gnome-terminal+Exec=/usr/bin/gnome-terminal -v -- /bin/bash -c '$HOME/.local/bin/continue_setup.sh;exec $SHELL'+\" ~/.config/autostart/org.gnome.Terminal.desktop"

if [[ "$error" = false ]]; then
    echo "The system will reboot in 5 seconds..."
    sleep 5
    sudo reboot
else
    echo "Not all commands succeeded"
fi
