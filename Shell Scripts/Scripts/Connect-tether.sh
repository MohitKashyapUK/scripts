#!/bin/bash

# Connect the mobile using USB cable
# Set USB mode to charging only or file transfer
# Open EasyTether app and turn on USB button
# Then run these commands on the PC:

sudo easytether-usb
sudo dhcpcd tap-easytether

# echo "Press any key to exit.$0"
echo ""
read -n 1 -s -r -p "Press any key to close..."
