#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/pc1.txt 2>&1
paperclipai --help 2>&1 | cut -c1-110 | head -40
echo "--- company"; paperclipai company --help 2>&1 | cut -c1-110 | head -15
echo "--- agent"; paperclipai agent --help 2>&1 | cut -c1-110 | head -15
echo "--- browsers: $(command -v firefox chromium google-chrome 2>/dev/null | tr '\n' ' ')"
echo "api: $(curl -s -m 5 http://127.0.0.1:3100/api/health | cut -c1-120)"
echo PC1_DONE
