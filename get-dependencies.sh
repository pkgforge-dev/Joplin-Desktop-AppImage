#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libnss_nis nss-mdns nss

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

echo "Getting binary..."
echo "---------------------------------------------------------------"
# Upstream only has a single deb that is x86_64 and has no arch in it
link=$(wget https://api.github.com/repos/laurent22/joplin/releases/latest -O - \
	| sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*/Joplin-.*.deb")
wget --retry-connrefused --tries=30 "$link" -O /tmp/temp.deb
ar x /tmp/temp.deb
tar -xvf ./data.tar.xz
rm -f ./*.tar.xz /tmp/temp.deb

mkdir -p ./AppDir/bin
cp -vr ./opt/Joplin/*                                    ./AppDir/bin
cp -v  ./usr/share/applications/joplin.desktop           ./AppDir
cp -v  ./usr/share/icons/hicolor/512x512/apps/joplin.png ./AppDir
cp -v  ./usr/share/icons/hicolor/512x512/apps/joplin.png ./AppDir/.DirIcon

echo "$link" | awk -F'/' '{print $(NF-1)}' > ~/version
