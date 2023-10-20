#!/usr/bin/env bash
set -ex

# Detect architecture
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

# Download Azure Data Studio .deb package
wget -q https://azuredatastudio-update.azurewebsites.net/latest/linux-deb-x64/stable -O azure_data_studio.deb

# Install Azure Data Studio
apt-get update
apt-get install -y ./azure_data_studio.deb

# Update icon location
mkdir -p /usr/share/icons/hicolor/apps
wget -O /usr/share/icons/hicolor/apps/azuredatastudio.svg https://raw.githubusercontent.com/harrisonj94/kasm-azure-data-studio/main/img/azure-data-studio.svg
sed -i '/Icon=/c\Icon=/usr/share/icons/hicolor/apps/azuredatastudio.svg' /usr/share/applications/azuredatastudio.desktop

# Create desktop shortcut
cp /usr/share/applications/azuredatastudio.desktop $HOME/Desktop
chmod +x $HOME/Desktop/azuredatastudio.desktop
chown 1000:1000 $HOME/Desktop/azuredatastudio.desktop

# Remove downloaded .deb package
rm azure_data_studio.deb

# Conveniences for Python development
apt-get update
apt-get install -y python3-setuptools \
                   python3-venv \
                   python3-virtualenv

# Cleanup
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*
fi
