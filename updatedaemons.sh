#!/bin/sh
#Check if this is a Yocto image
if [ -d /home/root ]; then
# Define the expected OpenSSL version
cd /home/pi/src
./fixpi4ssl.sh
source /etc/profile
sleep 2
EXPECTED_OPENSSL_VERSION="1.1.1u"
FILE="/etc/profile.d/yocto_extra_packages.sh"
LINE_TO_CHECK='export LD_LIBRARY_PATH="/usr/local/lib/openssl/openssl/openssl/lib:$LD_LIBRARY_PATH"'
NEW_LINE='export LD_LIBRARY_PATH="/usr/local/lib/openssl/openssl/lib:$LD_LIBRARY_PATH"'

# Check if the file exists
if [ -f "$FILE" ]; then
    # Check if the line exists in the file
    if grep -qF "$LINE_TO_CHECK" "$FILE"; then
        # Replace the line
        sed -i "s|$LINE_TO_CHECK|$NEW_LINE|" "$FILE"
        echo "Line replaced in $FILE"
    else
        echo "Line not found in $FILE"
    fi
else
    echo "Error: File $FILE not found."
fi
# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get the installed OpenSSL version
INSTALLED_OPENSSL_VERSION=$(openssl version | awk '{print $2}')

# Compare the installed version with the expected version
if [ "$INSTALLED_OPENSSL_VERSION" == "$EXPECTED_OPENSSL_VERSION" ]; then
    echo "Correct: OpenSSL version $EXPECTED_OPENSSL_VERSION is installed."
else
    echo "Not Correct: Installed OpenSSL version is $INSTALLED_OPENSSL_VERSION, expected version $EXPECTED_OPENSSL_VERSION."
   cd /home/pi/src
    ./updatepi4.sh
fi
fi

# Ensure libaries are correctly linked 

library_path="/usr/local/lib/openssl/openssl/lib"
init_script="/etc/init.d/powertune"

# Check if the library path is already present in the init script
if grep -q "$library_path" "$init_script"; then
    echo "Library path already present in $init_script."
else
    # If not present, add the library path to the top of the file
    echo "Adding library path to $init_script."
    sed -i "1iexport LD_LIBRARY_PATH=\"$library_path:\$LD_LIBRARY_PATH\"" "$init_script"
fi

echo "Disable System Logs"
cd /home/pi/src
./fixlog.sh
echo "Install fonts"
cd /home/pi/src/fonts
sudo cp *.* /usr/local/share/fonts
echo "Fetching latest Daemons"
cd /home/pi/src
git pull
cd
echo "Killing all  Daemons"
sudo pkill AdaptronicCANd
sudo pkill AEMV2d
sudo pkill Apexid
sudo pkill AudiB7d
sudo pkill AudiB8d
sudo pkill BlackboxM3
sudo pkill BRZFRS86d
sudo pkill Consult
sudo pkill Emtrond
sudo pkill EMUCANd
sudo pkill EVOXCAN
sudo pkill FordBarraBXCAN
sudo pkill FordBarraBXCANOBD
sudo pkill FordBarraFG2xCAN
sudo pkill FordBarraFG2XCANOBD
sudo pkill FordBarraFGMK1CAN
sudo pkill FordBarraFGMK1CANOBD
sudo pkill GMCANd
sudo pkill Haltechd
sudo pkill Holleyd
sudo pkill Hondatad
sudo pkill Linkd
sudo pkill M800ADLSet1d
sudo pkill M800ADLSet3d
sudo pkill MaxxECUd
sudo pkill Microtechd
sudo pkill MotecM1d
sudo pkill NISSAN370Z
sudo pkill NISSAN350Z
sudo pkill OBD
sudo pkill MegasquirtCan
sudo pkill EMSCAN
sudo pkill WRX2012
sudo pkill Testdaemon
sudo pkill ecoboost
sudo pkill Emerald
sudo pkill WolfEMS
sudo pkill GMCANOBD
sudo pkill genericcan
sudo pkill FTCAN20
sudo pkill Delta
sudo pkill BigNET
sudo pkill R35
sudo pkill Prado
sudo pkill ProEFI
sudo pkill TeslaSDU
sudo pkill DTAFast
sudo pkill GR_Yaris
sudo pkill Syvecs
sudo pkill Rsport
sudo pkill Generic
echo "Removing previous Versions"

sudo rm /home/pi/daemons/ProEFI
sudo rm /home/pi/daemons/DTAFast
sudo rm /home/pi/daemons/TeslaSDU
sudo rm /home/pi/daemons/AdaptronicCANd
sudo rm /home/pi/daemons/AEMV2d
sudo rm /home/pi/daemons/Apexid
sudo rm /home/pi/daemons/AudiB7d
sudo rm /home/pi/daemons/AudiB8d
sudo rm /home/pi/daemons/BlackboxM3
sudo rm /home/pi/daemons/BRZFRS86d
sudo rm /home/pi/daemons/Consult
sudo rm /home/pi/daemons/Emtrond
sudo rm /home/pi/daemons/EMUCANd
sudo rm /home/pi/daemons/EMSCAN
sudo rm /home/pi/daemons/EVOXCAN
sudo rm /home/pi/daemons/FordBarraBXCAN
sudo rm /home/pi/daemons/FordBarraBXCANOBD
sudo rm /home/pi/daemons/FordBarraFG2xCAN
sudo rm /home/pi/daemons/FordBarraFG2XCANOBD
sudo rm /home/pi/daemons/FordBarraFGMK1CAN
sudo rm /home/pi/daemons/FordBarraFGMK1CANOBD
sudo rm /home/pi/daemons/Haltechd
sudo rm /home/pi/daemons/Holleyd
sudo rm /home/pi/daemons/Hondatad
sudo rm /home/pi/daemons/Linkd
sudo rm /home/pi/daemons/M800ADLSet1d
sudo rm /home/pi/daemons/M800ADLSet3d
sudo rm /home/pi/daemons/MaxxECUd
sudo rm /home/pi/daemons/Microtechd
sudo rm /home/pi/daemons/MotecM1d
sudo rm /home/pi/daemons/NISSAN370Z
sudo rm /home/pi/daemons/NISSAN350Z
sudo rm /home/pi/daemons/OBD
sudo rm /home/pi/daemons/GMCANd
sudo rm /home/pi/daemons/MegasquirtCan
sudo rm /home/pi/daemons/WRX2012
sudo rm /home/pi/daemons/Testdaemon
sudo rm /home/pi/daemons/ecoboost
sudo rm /home/pi/daemons/WolfEMS
sudo rm /home/pi/daemons/GMCANOBD
sudo rm /home/pi/daemons/genericcan
sudo rm /home/pi/daemons/FTCAN20
sudo rm /home/pi/daemons/Delta
sudo rm /home/pi/daemons/BigNET
sudo rm /home/pi/daemons/R35
sudo rm /home/pi/daemons/Prado
sudo rm /home/pi/daemons/ECVOXCAN
sudo rm /home/pi/daemons/Emerald
sudo rm /home/pi/daemons/Hondata
sudo rm /home/pi/daemons/HondataS300
sudo rm /home/pi/daemons/LifeRacing
sudo rm /home/pi/daemons/ME13
sudo rm /home/pi/daemons/NeuroBasic
sudo rm /home/pi/daemons/PTDCAND
sudo rm /home/pi/daemons/RX8
sudo rm /home/pi/daemons/WRX2016
sudo rm /home/pi/daemons/BigNETLamda
sudo rm /home/pi/daemons/GR_Yaris
sudo rm /home/pi/daemons/Syvecs
sudo rm /home/pi/daemons/Rsport
sudo rm /home/pi/daemons/Generic
sudo rm /home/pi/daemons/checkall
sudo rm /home/pi/daemons/checkall2

echo "Updating Daemons"
cp -r /home/pi/src/daemons/. /home/pi/daemons/
cd /home/pi/src
cp /home/pi/src/*.sh /home/pi/
cd /home/pi/daemons
./checkall
