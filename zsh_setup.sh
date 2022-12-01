#!/bin/bash

font_dir="/usr/share/fonts/firacode"

sudo rm -rf $font_dir && \
sudo mkdir -p $font_dir && \
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O $font_dir/firacode.zip && \
sudo unzip $font_dir/firacode.zip -d $font_dir && \
sudo find $font_dir -type f ! \( -name '*Complete.ttf' -o -name '*Mono.ttf' \) -delete && \
fc-cache -f -v


ln .zshrc $HOME/.zshrc
chsh -s $(which zsh)

mkdir -p $HOME/.config/starship/
ln starship.toml $HOME/.config/starship/starship.toml
curl -sS https://starship.rs/install.sh | sh -s -- -y

