#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov10.txt 2>&1
echo "ollama: $(systemctl --user is-active ollama)  api: $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://127.0.0.1:11434/)"
free -m | sed -n 2p
echo "== ollama log"; journalctl --user -u ollama --since "-60 min" --no-pager | grep -v -E "GET|POST" | tail -8 | cut -c1-200
echo "== models"; ollama list 2>&1 | cut -c1-90
echo OV10_DONE
