#!/usr/bin/bash

sudo yes | git clone https://aur.archlinux.org/yay-git.git /opt

USER="$(id -run)"
sudo chown -R $USER:$USER /opt/yay-git

yes | makepkg -D /opt/yay-git -si

sudo yay -Suy --noconfirm
