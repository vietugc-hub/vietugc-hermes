#!/bin/bash
echo "== stt keys"; python3 - <<'PY'
import re
t=open('/home/agent/.hermes/config.yaml').read().splitlines()
i=[k for k,l in enumerate(t) if l.startswith('stt:')][0]
for l in t[i:i+60]:
    if l.strip() and not l.strip().startswith('#') and (l.startswith(' ') or l.startswith('stt')): print(l)
    elif l and not l.startswith(' ') and not l.startswith('#') and not l.startswith('stt'): break
PY
echo "== native Hermes STT test"
P=$(ls -d ~/.hermes/installs/*/environments/*/venv | head -1)
cd ~/.hermes/hermes-agent && "$P/bin/python" - <<'PY' 2>&1 | tail -6
import inspect
from tools import transcription_tools as t
fn=getattr(t,'transcribe_audio',None)
print('transcribe_audio exists:',bool(fn))
if fn:
    r=fn('/tmp/vc17.mp3'); print('RESULT:',str(r)[:300])
PY
echo VC30_DONE
