#!/bin/bash
# read-only server survey; output to ~/survey.txt
{
echo "== date"; date
echo "== os"; lsb_release -ds 2>/dev/null; uname -r
echo "== cpu/ram/disk"; nproc; free -h | sed -n 1,2p; df -h / | tail -1
echo "== tools"
for t in git curl docker podman node npm pnpm python3 pip3 uv go cargo hermes; do printf "%s: " $t; (command -v $t >/dev/null && ($t --version 2>&1 | head -1)) || echo MISSING; done
echo "== docker group"; id
echo "== listening ports"; ss -ltnp 2>/dev/null | awk 'NR>1{print $4, $6}' | head -30
echo "== hermes"; hermes --version 2>&1 | head -2; systemctl --user list-units --type=service --no-pager 2>/dev/null | grep -i -E "hermes|paperclip|sandbox|viking" 
echo "== home dirs"; ls -A ~ | head -50
echo "== sudo"; sudo -n true 2>&1 | head -1
} > ~/survey.txt 2>&1
echo SURVEY_DONE
