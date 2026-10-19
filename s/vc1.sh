#!/bin/bash
# Read-only check: Hermes version, voice/TTS setup, dashboard/kanban availability. Writes ~/vc1.txt
O=~/vc1.txt
{
echo "== version"; hermes --version 2>&1 | head -3
echo "== ffmpeg"; which ffmpeg; ffmpeg -version 2>&1 | head -1
echo "== free mem"; free -m | head -2
echo "== config voice/tts lines"; grep -n -i -B1 -A6 -E '^(tts|voice|stt)' ~/.hermes/config.yaml 2>&1 | head -40
echo "== env key NAMES only"; cut -d= -f1 ~/.hermes/.env 2>/dev/null | grep -v '^#' | grep -v '^$' | tr '\n' ' '; echo
PY=$(ls ~/.hermes/hermes-agent/venv/bin/python 2>/dev/null || which python3)
echo "== python modules ($PY)"
for m in edge_tts nacl discord faster_whisper; do $PY -c "import $m" 2>/dev/null && echo "$m OK" || echo "$m MISSING"; done
echo "== gateway log voice/tts/audio (last 2h)"
journalctl --user -u hermes-gateway --since "2 hours ago" --no-pager 2>/dev/null | grep -i -E 'tts|voice|ffmpeg|audio|edge' | tail -15
echo "== dashboard/kanban commands"
hermes dashboard --help 2>&1 | head -3
hermes kanban --help 2>&1 | head -3
echo "== custom provider hint"
grep -n -i -E 'provider|base_url|model' ~/.hermes/config.yaml 2>&1 | head -12
echo DONE
} > $O 2>&1
