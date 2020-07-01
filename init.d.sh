#!/bin/bash

sudo apt-get update
sudo apt-get install -y wine-development unzip

useradd -r -s /bin/false -m acc

curl -o /tmp/acc-server-install.zip %INSTALL_URL
sudo -u acc unzip /tmp/acc-server-install.zip -d /home/acc/server

sudo tee -a /etc/systemd/system/acc.service > /dev/null <<EOT
[Unit]
Description=ACC Multiplayer Server
After=network.target

[Service]
User=acc
Group=acc
WorkingDirectory=/home/acc/server
ExecStart=/usr/bin/wine ./accServer.exe

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable acc.service
