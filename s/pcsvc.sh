#!/bin/bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
exec > ~/pcsvc.txt 2>&1
pkill -f "paperclipai@latest onboard" ; pkill -f "paperclipai" ; sleep 3
npx --yes paperclipai@latest service install
npx --yes paperclipai@latest service start
sleep 20
npx --yes paperclipai@latest service status
echo "http: $(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3100/)"
echo PCSVC_DONE
