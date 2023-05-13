#!/bin/bash

# Define the path to the WPA_supplicant configuration file
WPA_SUPPLICANT_CONF=/etc/wpa_supplicant/wpa_supplicant.conf

# Define the name of the wireless interface
WIRELESS_INTERFACE=wlan0

# Define the path to the NetworkManager system connections folder
SYSTEM_CONNECTIONS_FOLDER=/etc/NetworkManager/system-connections/

# Get the SSID of the wireless network
echo "Enter the SSID of the wireless network:"
read SSID

# Add the unmanaged-devices option to the NetworkManager configuration file
echo "" >> /etc/NetworkManager/NetworkManager.conf
echo "[keyfile]" >> /etc/NetworkManager/NetworkManager.conf
echo "unmanaged-devices=interface-name:$WIRELESS_INTERFACE" >> /etc/NetworkManager/NetworkManager.conf

# Create a new system connection file for the wireless network
echo "" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "[connection]" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "id=$SSID" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "uuid=$(uuidgen)" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "type=wifi" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "[wifi]" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "ssid=$SSID" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "mode=infrastructure" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "security=802-11-wireless-security" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "[802-11-wireless-security]" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "key-mgmt=wpa-psk" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "psk=" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
cat $WPA_SUPPLICANT_CONF | grep -A 1 "ssid=\"$SSID\"" | grep psk | sed 's/psk=//' >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "[ipv4]" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "method=auto" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "[ipv6]" >> $SYSTEM_CONNECTIONS_FOLDER$SSID
echo "method=auto" >> $SYSTEM_CONNECTIONS_FOLDER$SSID

# Restart the NetworkManager service
service networkmanager restart

echo "The configuration for $SSID has been saved to NetworkManager."
