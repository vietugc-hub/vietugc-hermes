#!/bin/bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
{ npx --yes paperclipai@latest --help 2>&1 | head -40; echo; ls ~/.npm/_npx 2>/dev/null | head; which node; } > ~/pchelp.txt 2>&1
echo HELP_DONE
