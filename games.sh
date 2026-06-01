#!/bin/bash
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
yay -S --noconfirm steam heroic-games-launcher protonplus atlauncher
