#!/bin/bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
{ npx --yes paperclipai@latest service --help 2>&1 | head -30; } > ~/svchelp.txt 2>&1
echo SVC_DONE
