#!/bin/bash
{
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do
  if "$p/bin/python" -c "import edge_tts" 2>/dev/null; then
    echo "before: $("$p/bin/python" -m pip show edge-tts 2>/dev/null | grep ^Version)"
    "$p/bin/python" -m pip install -q -U edge-tts 2>&1 | tail -2 || uv pip install -q -U --python "$p/bin/python" edge-tts 2>&1 | tail -2
    echo "after:  $("$p/bin/python" -m pip show edge-tts 2>/dev/null | grep ^Version)"
    "$p/bin/python" - <<'PY'
import asyncio, edge_tts
async def m():
    await edge_tts.Communicate("Good morning Leif","en-US-AriaNeural").save("/tmp/vc16.mp3")
try:
    asyncio.run(m()); import os; print("TTS test OK bytes", os.path.getsize("/tmp/vc16.mp3"))
except Exception as e: print("TTS test FAILED:", str(e)[:150])
PY
  fi
done
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC16_DONE
} 2>&1 | tee ~/vc16.txt
