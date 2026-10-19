#!/bin/bash
# Install ffmpeg (needed for Hermes spoken replies) then restart the gateway. Asks for the server password once (sudo). Writes ~/vc13.txt
echo
echo "TYPE the server password now and press Enter. Nothing will show while you type."
sudo apt-get install -y ffmpeg
echo "== result"
{ which ffmpeg; ffmpeg -version 2>&1 | head -1; } | tee ~/vc13.txt
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)" | tee -a ~/vc13.txt
echo VC13_DONE | tee -a ~/vc13.txt
