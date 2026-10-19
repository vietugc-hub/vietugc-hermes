#!/bin/bash
# Read-only: how Hermes installs edge-tts, plus the Hermes Discord voice doctor using its own venv. Writes ~/vc9.txt
O=~/vc9.txt
H=~/.hermes/hermes-agent
{
echo "== extras mentioning edge/tts/voice"; grep -n -i -E 'edge|tts|voice|messaging' $H/pm/extras.py | head -14
echo "== tts config in config.yaml"; grep -n -i -A8 -E '^tts:' ~/.hermes/config.yaml | grep -v '^[0-9]*-\s*#' | head -14
echo "== voice doctor"; $H/.venv/bin/python $H/scripts/discord-voice-doctor.py 2>&1 | tail -26
echo VC9_DONE
} > $O 2>&1
cat $O
