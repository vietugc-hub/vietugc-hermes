#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov8.txt 2>&1
ov abstract viking://resources/linux-hq 2>&1 | head -4 | cut -c1-400
echo "== find"; ov find "why is Ollama installed" 2>&1 | grep -A3 -E "^[0-9]+\. resource" | head -16 | cut -c1-220
echo OV8_DONE
