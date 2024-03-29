#!/bin/bash

# ASCII Startup Screen
clear

echo "====================================="
echo "          Auto Setup Script          "
echo "              Daniel00001            "
echo "====================================="

# Function to wait for a process to complete
wait_for_process() {
    while pgrep -x "$1" >/dev/null; do
        echo "Waiting for $1 to finish..."
        sleep 1
    done
}

# Unset existing GOPATH
unset GOPATH

# 1. Preparing the Development Tools
sudo apt-get update && sudo apt-get install -y make gcc
wait_for_process "apt-get"

wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
wait_for_process "tar"

# Create directory if it does not exist
mkdir -p /home/user1/go/src/github.com/artela-network
go env -w "GOPATH=/home/user1/go"

# 2. Cloning and Building the Code
cd /home/user1/go/src/github.com/artela-network
git clone https://github.com/artela-network/artela.git
wait_for_process "git"

cd artela
make clean && make
wait_for_process "make"

make install
wait_for_process "make"

# 3. Starting the Testnet
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-compose
wait_for_process "apt"

sudo systemctl status docker
docker run hello-world

cd artela
make create-testnet
wait_for_process "make"

echo "Auto Completed powered by Daniel00001"
