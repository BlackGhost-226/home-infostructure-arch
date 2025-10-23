#!/usr/bin/bash

mkdir -p ~/.local/share/applications
cp /usr/share/applications/firefox.desktop ~/.local/share/applications/
echo "Exec=env MOZ_ENABLE_WAYLAND=0 firefox %u" >> ~/.local/share/applications/firefox.desktop
