#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov13.txt 2>&1
ollama pull qwen2.5:1.5b 2>&1 | tail -1
U=~/.config/systemd/user/ollama.service
grep -q MAX_LOADED $U || sed -i 's|^Environment=OLLAMA_HOST=.*|& OLLAMA_MAX_LOADED_MODELS=1 OLLAMA_NUM_PARALLEL=1 OLLAMA_KEEP_ALIVE=2m|' $U
grep -n Environment $U | cut -c1-160
systemctl --user daemon-reload; systemctl --user restart ollama; sleep 8; systemctl --user restart openviking; sleep 20
echo "== speed test"
curl -s -m 120 http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5:1.5b","prompt":"Summarize in one sentence: Ollama runs free local models for OpenViking.","stream":false,"options":{"num_predict":40}}' | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['response'][:160]);print('tok/s',round(d['eval_count']/(d['eval_duration']/1e9),2))"
free -m | sed -n 2p
ov add-resource ~/ovdocs --to viking://resources/linux-hq --wait 2>&1 | tail -2 | cut -c1-160
echo OV13_DONE
