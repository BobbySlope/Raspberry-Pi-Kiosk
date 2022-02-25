#!/bin/bash

#sudo wget -q -O - https://raw.githubusercontent.com/BobbySlope/Raspberry-Pi-Kiosk/main/install.sh | sudo bash -

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

echo "Setup Autologin to CLI...."
sudo mkdir /lib/systemd/system/getty@tty1.service.d/
cat > /lib/systemd/system/getty@tty1.service.d/20-autologin.conf <<EOL
#Autologin to Console
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin hoobs --noclear %I $TERM
EOL
echo "----------------------------------------------------------------"
echo "Autologin CLI Installed"
echo "----------------------------------------------------------------"

echo "add kiosk script...."
sudo rm -rf /opt/kiosk.sh
cat > /opt/kiosk.sh <<EOL
#!/bin/sh
xset dpms
xset s noblank
xset s 300
openbox-session &
DISPLAY=:0 chromium /
--no-first-run /
--disable /
--disable-translate /
--disable-infobars /
--disable-suggestions-service /
--disable-save-password-bubble /
--start-maximized /
--kiosk /
--disable-session-crashed-bubble /
--incognito /
http://localhost
EOL

echo "make script executable...."
sudo chmod 777 /opt/kiosk.sh

echo -e "* Create service file"
sudo rm -rf /home/hoobs/chromiumkiosk.service
cat <<EOF > /home/hoobs/chromiumkiosk.service
[Unit]
Description=Chromium Onboot
After=graphical-session.target

[Service]
User=hoobs
ExecStart=  /opt/kiosk.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo -e "* Security Init File"
mv /home/hoobs/chromiumkiosk.service /etc/systemd/system/chromiumkiosk.service

echo -e "* Startup Startup"
sudo systemctl deamon-reload
sudo systemctl enable chromiumkiosk.service

echo -e "* Starting Service"
sudo systemctl start chromiumkiosk.service

echo -e "* Rebooting in 20 seconds Press Ctrl+c to cancel"
sleep 20
sudo reboot -h now
