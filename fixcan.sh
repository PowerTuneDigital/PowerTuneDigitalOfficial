echo "repairing boot.txt"
sudo sed -i 's/dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=24/#dtoverlay=mcp2515-can1,oscillator=16000000,interrupt=24/g' /boot/config.txt
