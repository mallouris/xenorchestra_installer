#!/bin/bash
sudo apt-get install --yes nfs-common
cd /opt
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install --yes nodejs
sudo curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
sudo chmod +x /usr/local/bin/n
sudo n stable
sudo apt-get install --yes build-essential redis-server libpng-dev git python-minimal
sudo git clone -b stable https://github.com/vatesfr/xo-server
sudo git clone -b stable https://github.com/vatesfr/xo-web
sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
cd /opt/xo-server
sudo yarn install --force
cd /opt/xo-web
sudo yarn install --force
sudo cp sample.config.yaml .xo-server.yaml
sudo sed -i /mounts/a\\"    '/': '/opt/xo-web/dist'" .xo-server.yaml
sudo cp xo-server.service /etc/systemd/system/xo-server.service
sudo sed -i 's/Environment=.*/WorkingDirectory=\/opt\/xo-server\//' /etc/systemd/system/xo-server.service
sudo sed -i 's/ExecStart=.*/ExecStart=\/usr\/local\/bin\/node .\/bin\/xo-server\//' /etc/systemd/system/xo-server.service
sudo chmod +x /etc/systemd/system/xo-server.service
sudo systemctl enable xo-server.service
sudo systemctl start xo-server.service
