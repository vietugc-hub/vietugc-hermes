#!/bin/bash
# Token Harbor setup for Hermes. Asks for the key once (hidden), stores it in ~/.hermes/.env, points Hermes at DeepSeek V4.1 Flash (free). Writes ~/vc4.txt
O=~/vc4.txt
echo
echo "PASTE the Token Harbor key now, then press Enter. A star appears for each character (about 73 stars)."
K=""
while IFS= read -rsn1 c </dev/tty; do
  [ -z "$c" ] && break
  K="$K$c"; printf '*'
done
echo
echo "Received ${#K} characters."
case "$K" in thk_live_*) ;; *) echo "That does not look like a Token Harbor key. Run again and paste ONCE."; exit 1;; esac
if [ ${#K} -gt 100 ]; then echo "Pasted more than once (${#K} characters). Run again and paste ONCE, then press Enter."; exit 1; fi
{
cp ~/.hermes/config.yaml ~/.hermes/config.yaml.bak-before-tokenharbor
touch ~/.hermes/.env; chmod 600 ~/.hermes/.env
grep -v '^TOKENHARBOR_API_KEY=' ~/.hermes/.env > ~/.hermes/.env.tmp; mv ~/.hermes/.env.tmp ~/.hermes/.env
printf 'TOKENHARBOR_API_KEY=%s\n' "$K" >> ~/.hermes/.env; chmod 600 ~/.hermes/.env
echo "key saved: yes (length ${#K})"
echo "key looks right: $(echo "$K" | grep -c '^thk_live_')"
hermes config set model.provider custom 2>&1 | tail -1
hermes config set model.base_url https://tokenharbor.ai/v1 2>&1 | tail -1
hermes config set model.default deepseek-v4.1-flash:free 2>&1 | tail -1
hermes config set model.key_env TOKENHARBOR_API_KEY 2>&1 | tail -1
echo "== model block now"; awk '/^model:/{f=1;print;next} f&&/^[A-Za-z_]/{f=0} f' ~/.hermes/config.yaml | grep -v '^ *#' | grep -v '^$' | head -10
echo "== direct API test (no Hermes)"
curl -s -m 60 https://tokenharbor.ai/v1/chat/completions -H "Authorization: Bearer $K" -H 'content-type: application/json' -d '{"model":"deepseek-v4.1-flash:free","messages":[{"role":"user","content":"Reply with exactly: TOKEN HARBOR OK"}],"max_tokens":20}' | python3 -c "import sys,json
try:
  d=json.load(sys.stdin); print(d['choices'][0]['message']['content'])
except Exception as e: print('ERR',e)"
echo "== hermes one-shot test"
timeout 120 hermes chat -q "Reply with exactly: HERMES DEEPSEEK OK" 2>&1 | tail -6
echo VC4_DONE
} > $O 2>&1
unset K
cat $O | head -30
