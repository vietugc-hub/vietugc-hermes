#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/hv2.txt 2>&1
systemctl --user restart hermes-gateway; sleep 15
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo "services: ollama=$(systemctl --user is-active ollama) openviking=$(systemctl --user is-active openviking) sandbox=$(systemctl --user is-active opensandbox) paperclip=$(systemctl --user is-active paperclipai)"
journalctl --user -u hermes-gateway -n 40 --no-pager | grep -i -E "openviking|memory|error" | tail -5 | cut -c1-170
echo HV2_DONE
