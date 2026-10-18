#!/bin/bash
# Paperclip onboard (loopback only). log: ~/paperclip.log
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
mkdir -p ~/paperclip-run && cd ~/paperclip-run
nohup npx --yes --registry https://registry.npmjs.org paperclipai@latest onboard --yes > ~/paperclip.log 2>&1 &
echo "started pid $!"
