#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov11.txt 2>&1
free -m | sed -n 2p
ollama pull qwen2.5:1.5b 2>&1 | tail -1
cp -n ~/.openviking/ov.conf ~/.openviking/ov.conf.bak
grep -n "qwen3.5:4b" ~/.openviking/ov.conf | cut -c1-120
sed -i 's|ollama/qwen3.5:4b|ollama/qwen2.5:1.5b|' ~/.openviking/ov.conf
grep -n "qwen2.5" ~/.openviking/ov.conf | cut -c1-120
ollama stop qwen3.5:4b 2>/dev/null
systemctl --user restart openviking; sleep 20
time (curl -s -m 120 http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5:1.5b","prompt":"Summarize in one sentence: Ollama runs free local models for OpenViking.","stream":false,"options":{"num_predict":40}}' | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['response'][:200]);print('tok/s',round(d['eval_count']/(d['eval_duration']/1e9),2))")
ov add-resource ~/ovdocs --to viking://resources/linux-hq --wait 2>&1 | tail -2 | cut -c1-160
echo OV11_DONE
