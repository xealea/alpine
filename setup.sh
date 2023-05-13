#!/bin/sh

# Script to add user and install packages on Alpine Linux

# Add user
doas adduser lea input
doas adduser lea video
doas adduser lea audio

# List of packages to install, sorted alphabetically
packages="acpi alacritty \
          consolekit2 cpufreqd curl dbus dhcpcd dmenu \
          dunst eudev feh gvfs htop i3lock \
          kitty libinput-libs libxcb libxkbcommon light \
          lightdm lightdm-gtk-greeter linux-edge maim \
          mesa-dri-gallium \
          neofetch neovim network-manager-applet \
          networkmanager networkmanager-cli \
          networkmanager-openrc networkmanager-openvpn networkmanager-tui \
          networkmanager-wifi nodejs pavucontrol \
          pciutils playerctl polkit polkit-elogind powertop \
          pulseaudio pulseaudio-alsa pulseaudio-ctl \
          pulseaudio-jack sway setxkbmap shadow \
          terminus-font thunar transmission-qt \
          udiskie wireless-tools \
          xorg-server xf86-input-libinput xfce4-power-manager \
          xfce4-terminal xrandr zzz"

# Parse command line options
while [ $# -gt 0 ]
do
    case "$1" in
        --nvidia)
            packages="$packages nvidia nvidia-settings"
            ;;
        --amd)
            packages="$packages xf86-video-amdgpu mesa-vulkan-radeon libva-mesa-driver"
            ;;
        --intel)
            packages="$packages xf86-video-intel mesa-vulkan-intel"
            ;;
        *)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

# Install packages
doas apk add $packages

# Activate services that require rc-update
doas rc-update add lightdm default
doas rc-update add dbus default
doas rc-update add udev sysinit
doas rc-update add udev-trigger sysinit
doas rc-update add udev-settle sysinit
doas rc-update add udiskie default
doas rc-update add acpid default
doas rc-update add elogind default
doas rc-update add powertop default

# Disable wpa_supplicant and enable NetworkManager
doas rc-update del wpa_supplicant default
doas rc-update add NetworkManager default

# Enable hardware drivers
doas rc-update add hwdrivers sysinit

# End of script
