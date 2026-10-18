#!/bin/bash
exec > ~/docker.txt 2>&1
sudo -n true || { echo "NO_SUDO_CACHE"; exit 1; }
sudo -n apt-get update -qq
sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
sudo -n usermod -aG docker agent
sudo -n systemctl enable --now docker
sudo -n docker --version
sudo -n docker run --rm hello-world | head -3
echo DOCKER_DONE
