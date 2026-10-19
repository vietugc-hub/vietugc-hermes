#!/bin/bash
{
UV=$(command -v uv || ls ~/.local/bin/uv ~/.hermes/**/uv 2>/dev/null | head -1)
echo "uv: ${UV:-none}"
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do
  if "$p/bin/python" -c "import edge_tts" 2>/dev/null; then
    echo "before: $("$p/bin/python" -c 'import importlib.metadata as m;print(m.version("edge-tts"))')"
    [ -n "$UV" ] && "$UV" pip install -q -U --python "$p/bin/python" edge-tts 2>&1 | tail -2
    echo "after:  $("$p/bin/python" -c 'import importlib.metadata as m;print(m.version("edge-tts"))')"
    "$p/bin/python" - <<'PY'
import asyncio, edge_tts, os
async def m():
    await edge_tts.Communicate("Good morning Leif","en-US-AriaNeural").save("/tmp/vc17.mp3")
try:
    asyncio.run(m()); print("TTS test OK bytes", os.path.getsize("/tmp/vc17.mp3"))
except Exception as e: print("TTS test FAILED:", str(e)[:120])
PY
  fi
done
systemctl --user restart hermes-gateway; sleep 6
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC17_DONE
} 2>&1 | tee ~/vc17.txt
