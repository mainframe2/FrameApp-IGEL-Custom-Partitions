#!/bin/bash
#set -x
#trap read debug

# Creating an IGELOS CP for TeamViewer
## Development machine (Ubuntu 18.04)
# Obtain latest package and save into Downloads
# Download Latest App for Linux (Debian)
# https://www.teamviewer.com/en-us/download/linux/
# teamviewer_15.24.5_amd64.deb
if ! compgen -G "$HOME/Downloads/teamviewer_*_amd64.deb" > /dev/null; then
  echo "***********"
  echo "Obtain latest .deb package, save into $HOME/Downloads and re-run this script "
  echo "https://www.teamviewer.com/en-us/download/linux/"
  echo "***********"
  exit 1
fi

MISSING_LIBS="libminizip1 libxcb-xinerama0"

sudo apt install unzip -y

mkdir build_tar
cd build_tar

for lib in $MISSING_LIBS; do
  apt-get download $lib
done

mkdir -p custom/teamviewer

dpkg -x $HOME/Downloads/teamviewer_*_amd64.deb custom/teamviewer

find . -type f -name "*.deb" | while read LINE
do
  dpkg -x "${LINE}" custom/teamviewer
done

mv custom/teamviewer/usr/share/applications/ custom/teamviewer/usr/share/applications.mime
mkdir -p custom/teamviewer/userhome/.config/teamviewer

wget https://github.com/IGEL-Community/IGEL-Custom-Partitions/raw/master/CP_Packages/Apps/TeamViewer.zip

unzip TeamViewer.zip -d custom
mv custom/target/teamviewer-cp-init-script.sh custom

cd custom

tar cvjf teamviewer.tar.bz2 teamviewer teamviewer-cp-init-script.sh
mv teamviewer.tar.bz2 ../..
mv target/teamviewer.inf ../..
mv igel/*.xml ../..

cd ../..
rm -rf build_tar
