#!/bin/bash
{
UV=~/.local/bin/uv
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do
  "$UV" pip install -q --python "$p/bin/python" faster-whisper 2>&1 | tail -1
done
H=~/.hermes/hermes-agent/.hermes/bin/hermes
$H config set stt.provider local 2>&1 | tail -1
$H config set stt.local.model small 2>&1 | tail -1
# preload model + test with the TTS sample
P=$(ls -d ~/.hermes/installs/*/environments/*/venv | head -1)
"$P/bin/python" - <<'PY'
import glob
from faster_whisper import WhisperModel
m=WhisperModel("small",device="cpu",compute_type="int8")
f=(glob.glob("/tmp/vc17.mp3") or [None])[0]
if f:
    segs,_=m.transcribe(f); print("heard:"," ".join(s.text for s in segs))
print("STT model loaded OK")
PY
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC21_DONE
} 2>&1 | tee ~/vc21.txt
