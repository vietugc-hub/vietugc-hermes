#!/bin/bash
# Read-only: locate the python the Hermes gateway really uses and check voice modules in it. Writes ~/vc12.txt
O=~/vc12.txt
{
echo "== gateway ExecStart"; systemctl --user cat hermes-gateway 2>&1 | grep -E 'ExecStart|Environment' | cut -c1-200
echo "== pyvenv.cfg locations"; find ~/.hermes ~/.local/share/uv -maxdepth 6 -name pyvenv.cfg 2>/dev/null | head -6
PID=$(systemctl --user show -p MainPID --value hermes-gateway); echo "== running python: $(readlink -f /proc/$PID/exe 2>/dev/null)"
P=$(readlink -f /proc/$PID/exe 2>/dev/null)
for m in edge_tts nacl discord telegram; do $P -c "import $m" 2>/dev/null && echo "$m OK" || echo "$m MISSING"; done
echo VC12_DONE
} > $O 2>&1
cat $O
