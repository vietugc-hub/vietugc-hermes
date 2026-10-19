#!/bin/bash
{
echo "== tts log lines"
journalctl --user -u hermes-gateway -n 200 --no-pager | grep -iE "tts|edge|voice|audio|ffmpeg|opus|ogg" | tail -12 | cut -c1-220
echo "== tts config"
grep -n -iA6 "^tts" ~/.hermes/config.yaml | head -20
echo "== edge-tts importable?"
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do "$p/bin/python" -c "import edge_tts;print('edge_tts OK in $p')" 2>&1 | tail -1; done
echo VC15_DONE
} 2>&1 | tee ~/vc15.txt
