#!/bin/bash
{
cd ~/.hermes/hermes-agent
echo "== files"; ls tools | grep -i -E "transcr|stt|speech"
echo "== config keys"
grep -rn -E "stt|STT" hermes_cli/config.py 2>/dev/null | head -25 | cut -c1-200
echo "== gateway venv"
systemctl --user show hermes-gateway -p ExecStart | grep -o "/home/[^ ;]*python[^ ;]*" | head -1
echo VC19_DONE
} 2>&1 | tee ~/vc19.txt
