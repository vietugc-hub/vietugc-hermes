#!/bin/bash
# Read-only: Hermes' own python, which voice modules it has, and hermes doctor voice lines. Writes ~/vc11.txt
O=~/vc11.txt
H=~/.hermes/hermes-agent/.hermes
{
echo "== bin"; ls $H/bin | head -20 | tr '\n' ' '; echo
P=$H/bin/python; [ -x $P ] || P=$(ls $H/bin/python3 2>/dev/null)
echo "py=$P"
for m in hermes_cli edge_tts nacl discord telegram faster_whisper; do $P -c "import $m" 2>/dev/null && echo "$m OK" || echo "$m MISSING"; done
echo "== doctor (voice/tts/ffmpeg lines)"; timeout 90 hermes doctor 2>&1 | grep -i -E 'voice|tts|ffmpeg|opus|audio|speech|edge|warn|fail' | head -14
echo VC11_DONE
} > $O 2>&1
cat $O
