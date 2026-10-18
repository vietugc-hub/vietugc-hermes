#!/bin/bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
exec > ~/pcfix.txt 2>&1
npx --yes paperclipai@latest install --yes || npx --yes paperclipai@latest install
ls -l ~/.local/bin/paperclipai
systemctl --user reset-failed paperclipai.service
systemctl --user restart paperclipai.service
sleep 45
systemctl --user is-active paperclipai.service
echo "http: $(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3100/)"
echo "health: $(curl -s http://127.0.0.1:3100/api/health | cut -c1-120)"
echo PCFIX_DONE
