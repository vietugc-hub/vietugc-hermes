#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/osb2.txt 2>&1
echo "groups: $(id -nG)"
sed -n '1,/^\[store\]/p' ~/.sandbox.toml | grep -v -i -E "key|token|secret|password" | grep -v '^#' | grep -v '^$'
pkill -f opensandbox-server 2>/dev/null; sleep 1
nohup sg docker -c "uvx opensandbox-server" > ~/osb-server.log 2>&1 &
sleep 40
echo "--- listening"; ss -ltn | awk 'NR>1{print $4}' | grep -E ':(8080|8000|9000)$'
for p in 8080 8000; do echo "port $p: $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://127.0.0.1:$p/health)"; done
echo "--- server log tail"; tail -n 12 ~/osb-server.log | cut -c1-180
echo OSB2_DONE
