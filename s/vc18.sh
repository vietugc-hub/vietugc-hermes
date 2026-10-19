#!/bin/bash
{
echo "== stt config"
grep -n -iB1 -A8 "stt\|transcri" ~/.hermes/config.yaml | head -30
echo "== journal"
journalctl --user -u hermes-gateway -n 300 --no-pager | grep -iE "stt|transcri|whisper|voice" | tail -6 | cut -c1-230
echo "== modules"
for p in $(ls -d ~/.hermes/installs/*/environments/*/venv 2>/dev/null); do "$p/bin/python" -c "
import importlib.util as u
print('$p'[-40:], {m: bool(u.find_spec(m)) for m in ['faster_whisper','openai','groq']})"; done
echo "== free ram"; free -m | sed -n 2p
echo VC18_DONE
} 2>&1 | tee ~/vc18.txt
