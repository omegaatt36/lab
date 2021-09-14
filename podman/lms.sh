#!/bin/bash

podman create \
      --name=lms \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ=Asia/Taipei \
      -p 9000:9000/tcp \
      -p 9090:9090/tcp \
      -p 3483:3483/tcp \
      -p 3483:3483/udp \
      -v /home/raiven/lms/config:/config:rw \
      -v /home/raiven/lms/music:/music:ro \
      -v /home/raiven/lms/playlist:/playlist:rw \
      --restart always \
      lmscommunity/logitechmediaserver:latest

podman generate systemd --new --files --name lms

sudo cp -Z container-lms.service /etc/systemd/system
sudo systemctl enable container-lms.service
sudo systemctl start container-lms.service
sudo systemctl status container-lms.service