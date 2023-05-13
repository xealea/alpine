#!/bin/sh

# Script to add user and install packages on Alpine Linux

# Add user
doas adduser lea wheel
doas adduser lea input
doas adduser lea video
doas adduser lea audio

# List of packages to install, sorted alphabetically
packages="acpi alacritty autoconf automake build-base berry \
          consolekit2 cpufreqd curl dbus dbus-glib dhcpcd dmenu \
          dunst eudev elogind elogind-openrc fuse feh gettext git gvfs htop i3wm i3lock i3status \
          kitty libinput-libs libtool libxcb linux-firmware libxkbcommon light \
          lightdm lightdm-openrc lightdm-gtk-greeter maim \
          mesa-dri-gallium nano nemo \
          neofetch neovim nodejs pavucontrol \
          pciutils pkgconfig playerctl polkit polkit-elogind powertop \
          pulseaudio pulseaudio-alsa pulseaudio-ctl \
          pulseaudio-jack setxkbmap shadow \
          terminus-font transmission-qt \
          udisks2 udiskie \
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
        --i3conf)
            # Add i3wm configuration
            mkdir -p ~/.config/i3
            doas cp /etc/i3/config ~/.config/i3/config
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
doas rc-update add acpid default
doas rc-update add elogind default 
doas rc-update add cpufreqd default
doas rc-update add mdev sysinit
doas rc-update add fuse default

# Enable hardware drivers
doas rc-update add hwdrivers sysinit

# End of script
