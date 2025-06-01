#!/bin/bash

set -e

echo "==> Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "==> Removing old Docker versions if any..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

echo "==> Installing required dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

echo "==> Setting up Docker GPG keyring..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "==> Removing old Docker repo if exists..."
sudo rm -f /etc/apt/sources.list.d/docker.list

echo "==> Adding Docker repository (Debian Bookworm)..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Updating apt repositories..."
sudo apt update

echo "==> Installing Docker Engine and related packages..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "==> Adding current user to 'docker' group to run docker without sudo..."
sudo usermod -aG docker "$USER"

echo "==> Testing Docker installation..."
docker run --rm hello-world

echo "==> Done! You may need to log out and back in or run 'newgrp docker' for group changes to take effect."
