#!/bin/bash
# user-space toolchain: nvm + Node 24, uv. logs to ~/tools.log
exec > ~/tools.log 2>&1
set -x
curl -LsSf https://astral.sh/uv/install.sh | sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
. "$NVM_DIR/nvm.sh"
nvm install 24
nvm alias default 24
corepack enable 2>/dev/null || npm i -g pnpm
node -v; npm -v; ~/.local/bin/uv --version
echo TOOLS_DONE
