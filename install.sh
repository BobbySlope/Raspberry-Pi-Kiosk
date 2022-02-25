#!/bin/bash

#title           :install.sh
#description     :This script will create a service to open a chromium kiosk window in Raspbian Stretch and will also prevent any further user intervention 
#author		       :me@tonybenoy.com
#date            :26-04-2018
#version         :0.2   
#usage		       :sudo bash install.sh
#==============================================================================
echo -e "* Installing openbox"
sudo apt-get update
sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit xserver-xorg-video-fbdev openbox -y
sudo apt-get install --no-install-recommends chromium -y

echo -e "* Create startup script file"

cat <<EOF > /home/hoobs/script.sh
#! /bin/bash
rm -rf /home/hoobs/.config/chromium
rm -rf /home/hoobs/.cache/chromium
DISPLAY=:0 chromium-browser -kiosk http://localhost
EOF

chmod 777 /home/hoobs/script.sh

echo -e "* Removing Lxpanels"

sudo apt remove lxpanel -y
sudo apt autoremove -y

echo -e "* Create service file"

cat <<EOF > /home/hoobs/chromiumkiosk.service
[Unit]
Description=Chromium Onboot
After=graphical-session.target

[Service]
User=hoobs
Group=hoobs
ExecStart=  /home/hoobs/script.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo -e "* Security Init File"
mv /home/hoobs/chromiumkiosk.service /etc/systemd/system/chromiumkiosk.service

echo -e "* Startup Startup"
sudo systemctl enable chromiumkiosk.service

echo -e "* Starting Service"
sudo systemctl start chromiumkiosk.service

echo -e "* Rebooting in 20 seconds Press Ctrl+c to cancel"
sleep 20
sudo reboot -h now
