#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/osb4.txt 2>&1
K=$(cat ~/.osb-key 2>/dev/null || (openssl rand -hex 16 | tee ~/.osb-key)); chmod 600 ~/.osb-key
if grep -q -E '^\s*#?\s*api_key' ~/.sandbox.toml; then sed -i -E "s|^\s*#?\s*api_key\s*=.*|api_key = \"$K\"|" ~/.sandbox.toml
else sed -i "0,/^\[server\]/s||[server]\napi_key = \"$K\"|" ~/.sandbox.toml; fi
grep -n -E '^(host|port|api_key)' ~/.sandbox.toml | sed -E 's/(api_key = ).*/\1<set>/'
pkill -f opensandbox-server 2>/dev/null; sleep 1
nohup sg docker -c "uvx opensandbox-server" > ~/osb-server.log 2>&1 &
sleep 30
for p in 8080 8000; do echo "port $p health: $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://127.0.0.1:$p/health)"; done
ss -ltn | awk 'NR>1{print $4}' | grep -E ':(8080|8000)$'
tail -n 6 ~/osb-server.log | cut -c1-170
echo OSB4_DONE
