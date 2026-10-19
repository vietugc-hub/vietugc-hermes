#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov9.txt 2>&1
echo "== ollama ps"; ollama ps 2>&1 | cut -c1-120
echo "== cpu"; ps -eo pcpu,etime,args --sort=-pcpu | head -4 | cut -c1-110
echo "== openviking log (errors/semantic)"
journalctl --user -u openviking --since "-40 min" --no-pager | grep -i -E "error|fail|timeout|semantic|summar|vlm|queue" | tail -8 | cut -c1-230
echo OV9_DONE
