#!/bin/bash
exec > ~/osb6.txt 2>&1
export PATH="$HOME/.local/bin:$PATH"
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/opensandbox.service <<U
[Unit]
Description=Alibaba OpenSandbox server (loopback 127.0.0.1:8080)
After=network-online.target docker.service
[Service]
ExecStart=$HOME/.local/bin/uvx opensandbox-server
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
[Install]
WantedBy=default.target
U
pkill -f opensandbox-server; sleep 2
systemctl --user daemon-reload
systemctl --user enable --now opensandbox
sleep 25
echo "service: $(systemctl --user is-active opensandbox)  enabled: $(systemctl --user is-enabled opensandbox)"
echo "health: $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://127.0.0.1:8080/health)"
echo "paperclip: $(systemctl --user is-active paperclipai)  hermes: $(systemctl --user is-active hermes-gateway)"
echo OSB6_DONE
