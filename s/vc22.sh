#!/bin/bash
{
UV=~/.local/bin/uv
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do
  "$UV" pip install -q -U --python "$p/bin/python" av 2>&1 | tail -1
done
P=$(ls -d ~/.hermes/installs/*/environments/*/venv | head -1)
"$P/bin/python" - <<'PY'
from faster_whisper import WhisperModel
m=WhisperModel("small",device="cpu",compute_type="int8")
segs,_=m.transcribe("/tmp/vc17.mp3"); print("heard:"," ".join(s.text for s in segs))
PY
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC22_DONE
} 2>&1 | tee ~/vc22.txt
