#!/bin/bash
exec > ~/osb3.txt 2>&1
echo "uptime: $(uptime -p)"; free -m | sed -n '1,2p'; df -h / | tail -1
echo "--- osb2.txt"; cat ~/osb2.txt 2>/dev/null | cut -c1-160
echo "--- prev boot oom/kill"; journalctl -b -1 --no-pager 2>/dev/null | grep -i -E "out of memory|oom|killed process" | tail -5 | cut -c1-160
echo "--- prev boot last lines"; journalctl -b -1 --no-pager 2>/dev/null | tail -6 | cut -c1-160
echo "--- docker"; sg docker -c "docker ps -a --format '{{.Names}} {{.Status}}'" | head
echo OSB3_DONE
