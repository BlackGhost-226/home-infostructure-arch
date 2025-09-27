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
  yay -S --noconfirm hyprland mako python-requests \
    xdg-desktop-portal-hyprland wlroots xdg-utils wayland # hyprland

  yay -S --noconfirm brightnessctl gvfs bluez bluez-utils firewalld python3 # necessary utils | themes polkit-gnome

  yay -S --noconfirm grim slurp # screenshot utils

  yay -S --noconfirm hyprpaper swaylock-effects wlogout starship waybar pyenv neofetch cava mpv wine # additional utils

  yay -S --noconfirm wofi kitty dolphin ranger nm-connection-editor blueman # necessary apps

  yay -S --noconfirm vlc telegram-desktop kclock vlc-plugins-all vscodium-bin firefox # additional apps

  yay -S --noconfirm exfatprogs dosfstools

  yay -S --noconfirm syncthing # buckup server

  yay -S --noconfirm mesa # gpu drivers | greetd greetd-tuigreet vulkan-nouveau libegl vulkan-icd-loader
  read -n1 -rep 'Would you like to install nvidia drivers? (y,n)' GPU
  if [[ $GPU == "Y" || $GPU == "y" ]]; then
    yay -S --noconfirm nvidia # nvidia-dkms
  fi

  yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts-emoji # fonts

  echo -e "Starting Services...\n"
  # Start the bluetooth service
  sudo systemctl enable --now bluetooth.service

  # Start the firewall service
  sudo systemctl enable --now firewalld.service
  sudo firewall-cmd --zone=public --remove-service=ssh

  sudo systemctl disable sshd.service

  sleep 2

  # Clean out other portals
  echo -e "Cleaning out conflicting xdg portals...\n"
  yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi
