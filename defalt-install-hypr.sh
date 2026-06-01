#!/usr/bin/bash

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then
  echo -e "yay was located, moving on.\n"
  yay -Suy
else
  echo -e "yay was not located, please install yay. Exiting script.\n"
  exit
fi

### Disable wifi powersave mode ###
read -n1 -rep 'Would you like to disable wifi powersave? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
  LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
  echo -e "The following has been added to $LOC.\n"
  echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
  echo -e "\n"
  echo -e "Restarting NetworkManager service...\n"
  sudo systemctl restart NetworkManager
  sleep 3
fi

### Install all of the above pacakges ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
  # xfce4-settings?
  yay -S --noconfirm hyprland mako xdg-desktop-portal-hyprland wlroots xdg-utils wayland xorg-xwayland hyprpolkitagent sddm # hyprland | Fnott

  yay -S --noconfirm brightnessctl gvfs bluez bluez-utils firewalld polkit polkit-qt5 chrony hyprshutdown hyprland-qt-support # necessary utils

  yay -S --noconfirm grim slurp # screenshot utils

  yay -S --noconfirm hyprpaper hyprlock wlogout starship waybar neofetch cava wine hyprsysteminfo hyprpwcenter hyprqt6engine hyprlauncher # additional utils

  yay -S --noconfirm wofi kitty thunar ffmpegthumbnailer tumbler nm-connection-editor blueman # necessary apps

  yay -S --noconfirm vlc telegram-desktop kclock vlc-plugins-all visual-studio-code-bin librewolf copyq # additional apps

  yay -S --noconfirm python pyenv

  yay -S --noconfirm exfatprogs dosfstools ntfs-3g # disk formats support

  yay -S --noconfirm syncthing # buckup server

  yay -S --noconfirm mesa vulkan-radeon vulkan-intel nvidia # gpu drivers

  yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts-emoji # fonts


  echo -e "Starting Services...\n"
  # Start the bluetooth service
  sudo systemctl enable --now bluetooth.service

  # Start the firewall service
  sudo systemctl enable --now firewalld.service
  sudo firewall-cmd --zone=public --remove-service=ssh

  # disable SSH service
  sudo systemctl disable --now sshd.service

  sudo systemctl enable --now chronyd

  # SDDM setup
  sudo systemctl enable sddm.service # enable SDDM
  echo "" > /usr/share/wayland-sessions/hyprland.desktop
  
  echo "[Desktop Entry]" >> /usr/share/wayland-sessions/hyprland.desktop
  echo "Name=Hyprland" >> /usr/share/wayland-sessions/hyprland.desktop
  echo "Comment=Hyprland Wayland Compositor" >> /usr/share/wayland-sessions/hyprland.desktop
  echo "Exec=start-hyprland" >> /usr/share/wayland-sessions/hyprland.desktop
  echo "Type=Application" >> /usr/share/wayland-sessions/hyprland.desktop
  echo "DesktopNames=Hyprland" >> /usr/share/wayland-sessions/hyprland.desktop

  sleep 2

  # Clean out other portals
  echo -e "Cleaning out conflicting xdg portals...\n"
  yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi
