#!/bin/bash

# Clean up existing nvidia driver
sudo apt -y autoremove
sudo apt -y remove --purge '^nvidia-.*'
sudo apt -y remove --purge '^cuda-.*'

# Install Nvidia Driver
sudo apt-get -y install nvidia-common
sudo add-apt-repository -y ppa:graphics-drivers
sudo apt -y update
sudo ubuntu-drivers devices
sudo apt -y install nvidia-driver-545

# Install Cuda
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-u>sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-r>sudo dpkg -i cuda-repo-ubuntu2204-12-3-local_12.3.2-545.23.08-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get -y update
sudo apt-get -y install cuda-toolkit-12-3
sudo rm -rf cuda-ubuntu2204.pin cuda-repo-ubuntu2204-12-3-local_12.3.2-545.23.08-1_amd>

# Enter mediaserver directory
cd $HOME/mediaserver || exit

# npm install dependencies
npm i && npm i pm2 -g

# Clone nvidia-patch
git clone https://github.com/keylase/nvidia-patch.git

# Patch driver
cd nvidia-patch && sudo ./patch.sh && cd $HOME/mediaserver || exit

# Clone ffnvcodec
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

# Install ffnvcodec
cd nv-codec-headers && sudo make install && cd $HOME/mediaserver || exit

# Configure environment
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> $HOME/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64' >> $HOME/.bashrc

# Reload configuration
source $HOME/.bashrc
sudo ldconfig

# Get the Dependencies
sudo apt-get -y update -qq && sudo apt-get -y install autoconf automake build-essentia>

# Enter ZLMediaKit directory
cd $HOME/mediaserver/ZLMediaKit || exit

# Build and compile the ZLMediaKit
mkdir build
cd build
cmake ..
make -j4
cd $HOME/mediaserver || exit

# Running apps with PM2
pm2 start ecosystem.config.js && pm2 save
