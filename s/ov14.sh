#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov14.txt 2>&1
echo "== log last 6 min"; journalctl --user -u openviking --since "-6 min" --no-pager | grep -v -E "GET /|health" | tail -9 | cut -c40-230
echo "== ov tree"; ov tree viking://resources/linux-hq 2>&1 | head -8 | cut -c1-120
echo "== find"; ov find "why is Ollama installed" 2>&1 | grep -i -E "linux-hq|stack|briefing" | head -5 | cut -c1-200
echo OV14_DONE
