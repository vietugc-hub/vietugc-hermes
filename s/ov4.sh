#!/bin/bash
exec > ~/ov4.txt 2>&1
cat > ~/.config/systemd/user/openviking.service <<U
[Unit]
Description=OpenViking context database (loopback 127.0.0.1:1933)
After=ollama.service
[Service]
ExecStart=$HOME/.local/bin/openviking-server
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
Restart=on-failure
RestartSec=10
[Install]
WantedBy=default.target
U
systemctl --user daemon-reload; systemctl --user enable --now openviking; sleep 25
echo "openviking: $(systemctl --user is-active openviking)"
for u in health api/v1/health; do echo "$u: $(curl -s -m 5 -w ' [%{http_code}]' http://127.0.0.1:1933/$u | cut -c1-120)"; done
ss -ltn | awk 'NR>1{print $4}' | grep -E ':(1933|11434|8080|3100)$'
journalctl --user -u openviking -n 5 --no-pager | cut -c1-150
echo OV4_DONE
