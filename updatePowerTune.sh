#!/bin/sh
#Check if this is a Yocto image 
if [ -d /home/root ]; then
# Get the latest source
		echo "Yocto detected "
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
		echo "Fix rng "
                rm /etc/init.d/rng-tools
		if [ -d /home/Recoverysrc ]; then
	        cd /home/pi/Recoverysrc
		git pull
                ./updateRecovery.sh
                else
                mkdir /home/pi/Recoverysrc
                git clone https://github.com/PowerTuneDigital/PowerTuneDigitalRecovery.git /home/pi/Recoverysrc
                cd /home/pi/Recoverysrc
                ./updateRecovery.sh
                fi
		if [ -d /home/pi/src ]; then
		echo "Updating to latest source "
		cd /home/pi/src
		git reset --hard
		git clean -fd
		git pull
		./updatedaemons.sh
		./updateUserDashboards.sh
		else
		echo "Create source directory and clone PowerTune Repo"
		mkdir /home/pi/src
		git clone https://github.com/PowerTuneDigital/PowerTuneDigitalOfficial.git /home/pi/src
		cd src
		./updatedaemons.sh
		./updateUserDashboards.sh
		fi
# Check if the Logo Folder Exists
		if [ -d /home/pi/Logo ]; then
		echo "Logo folder exists"
		else
		echo "Create Logo Folder"
		mkdir /home/pi/Logo
		fi
# Check if there is a build folder
		if [ -d /home/pi/build ]; then
		echo "Delete previous build folder"
		sudo rm -r /home/pi/build
		mkdir /home/pi/build
		else
		mkdir /home/pi/build
		fi
# Compile PowerTune
		cd /home/pi/build
		echo "Compiling PowerTune ... go grab a Coffee"
		qmake /home/pi/src
		make -j4
# Check if the PowerTune executable exists in the build folder
		if [ -f /home/pi/build/PowertuneQMLGui ];then
		echo "Successfully compiled"
		sudo reboot
		else
		echo "Something went wrong"
		sudo rm -r /home/pi/build
		fi

# Raspbian image 
else
if nc -zw5 www.github.com 443; then
# Get the latest source
		if [ -d /home/pi/src ]; then
		echo "Updating to latest source "
		cd /home/pi/src
		git reset --hard
		git clean -fd
		git pull
		./fixcan.sh
		./updatedaemons.sh
		./updateUserDashboards.sh
		else
		echo "Create source directory and clone PowerTune Repo"
		mkdir /home/pi/src
		git clone https://github.com/PowerTuneDigital/PowerTuneDigitalOfficial.git /home/pi/src  
		cd src
		./fixcan.sh
		./updatedaemons.sh
		./updateUserDashboards.sh
		fi
# Check if the Logo Folder Exists
		if [ -d /home/pi/Logo ]; then
		echo "Logo folder exists"
		else
		echo "Create Logo Folder"
		mkdir /home/pi/Logo
		fi
# Check if the maptiles folder exists
		if [ -d /home/pi/maptiles];then
		sudo rm -r  /home/pi/maptiles/
                fi
# Check if there is a build folder
		if [ -d /home/pi/building ]; then
		echo "Delete previous build folder"
		sudo rm -r /home/pi/building
		mkdir /home/pi/building
		else
		mkdir /home/pi/building
		fi
# Compile PowerTune
		cd /home/pi/building
		echo "Compiling PowerTune ... go grab a Coffee"
		/opt/QT5/bin/qmake /home/pi/src
		make -j4
# Check if the PowerTune executable exists in the build folder
		if [ -f /home/pi/building/PowertuneQMLGui ];then
		echo "Successfully compiled"
		mv /home/pi/building /home/pi/build
		sudo reboot
		else
		echo "Something went wrong"
		sudo rm -r /home/pi/building
		fi
else
echo "Update not possible , Github not reachable check your connection "
fi
fi
