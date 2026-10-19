#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov6.txt 2>&1
ov language en 2>&1 | tail -1
echo "== add"; ov add-resource ~/ovdocs --to viking://resources/linux-hq --wait 2>&1 | tail -6 | cut -c1-200
echo "== tree"; ov tree viking://resources/linux-hq 2>&1 | head -12 | cut -c1-140
echo "== abstract (L0)"; ov abstract viking://resources/linux-hq 2>&1 | head -6 | cut -c1-300
echo "== find"; ov find "why is Ollama installed" 2>&1 | head -10 | cut -c1-200
echo OV6_DONE
