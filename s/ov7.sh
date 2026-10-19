#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov7.txt 2>&1
echo "== config help"; ov config --help 2>&1 | head -14 | cut -c1-130
[ -f ~/.openviking/ovcli.conf ] || echo '{"url":"http://127.0.0.1:1933"}' > ~/.openviking/ovcli.conf
echo "== add"; ov add-resource ~/ovdocs --to viking://resources/linux-hq --wait 2>&1 | tail -6 | cut -c1-200
echo "== tree"; ov tree viking://resources/linux-hq 2>&1 | head -10 | cut -c1-140
echo "== abstract"; ov abstract viking://resources/linux-hq 2>&1 | head -5 | cut -c1-300
echo "== find"; ov find "why is Ollama installed" 2>&1 | head -10 | cut -c1-200
echo OV7_DONE
