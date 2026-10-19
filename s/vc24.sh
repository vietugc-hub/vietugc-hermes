#!/bin/bash
{
UV=~/.local/bin/uv
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do
  "$UV" pip install -q --python "$p/bin/python" "av>=14,<17" 2>&1 | tail -2
done
P=$(ls -d ~/.hermes/installs/*/environments/*/venv | head -1)
"$P/bin/python" -c "import av;print('av',av.__version__)"
"$P/bin/python" - <<'PY'
from faster_whisper import WhisperModel
m=WhisperModel("small",device="cpu",compute_type="int8")
segs,_=m.transcribe("/tmp/vc17.mp3"); print("heard:"," ".join(s.text for s in segs))
PY
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC24_DONE
} 2>&1 | tee ~/vc24.txt
