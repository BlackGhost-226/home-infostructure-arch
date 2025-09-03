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

  yay -S --noconfirm themes polkit-gnome pamixer brightnessctl gvfs bluez bluez-utils firewalld python3 # necessary utils

  yay -S --noconfirm grim slurp # screenshot utils

  yay -S --noconfirm hyprpaper swaylock-effects wlogout starship waybar pyenv neofetch cava mpv # additional utils

  yay -S --noconfirm wofi kitty dolphin nm-connection-editor blueman # necessary apps

  yay -S --noconfirm vlc telegram-desktop kclock alsamixer vlc-plugins-all vscodium-bin firefox # additional apps

  yay -S --noconfirm libegl vulkan-icd-loader mesa greetd greetd-tuigreet vulkan-nouveau nvidia-utils nvidia nvidia-settings # gpu drivers i guess?

  yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts-emoji # fonts

  # Start the bluetooth service
  echo -e "Starting Services...\n"
  sudo systemctl enable --now bluetooth.service

  sudo systemctl enable --now firewalld.service
  sudo firewall-cmd --zone=public --remove-service=ssh

  sleep 2

  # Clean out other portals
  echo -e "Cleaning out conflicting xdg portals...\n"
  yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi
