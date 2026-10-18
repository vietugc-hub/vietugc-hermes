#!/bin/bash
exec > ~/st5.txt 2>&1
B=http://127.0.0.1:3100
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
A=$(curl -s $B/api/companies/$C/agents | python3 -c "import sys,json;d=json.load(sys.stdin);print([a['id'] for a in d if a['name']=='Stack Expert'][0])")
I=$(curl -s -X POST $B/api/companies/$C/issues -H 'content-type: application/json' -d "{\"title\":\"Test: explain the stack\",\"description\":\"Using only your instructions (do not search any history), answer in 6 short lines: (1) the four tools and what each is for, (2) what Docker and Ollama are for, (3) where status is kept. Post your answer as a comment on this task.\",\"assigneeAgentId\":\"$A\"}")
echo "issue: $(echo $I | cut -c1-200)"
IID=$(echo $I | python3 -c "import sys,json;print(json.load(sys.stdin)['id'])")
echo "wake: $(curl -s -m 15 -X POST $B/api/agents/$A/wakeup -H 'content-type: application/json' -d '{"reason":"first test"}' | cut -c1-200)"
for i in 1 2 3 4 5 6 7 8; do sleep 20
  S=$(curl -s $B/api/companies/$C/heartbeat-runs | python3 -c "import sys,json;d=json.load(sys.stdin);d=d if isinstance(d,list) else d.get('runs',[]);print([(r.get('status'),r.get('errorCode') or '') for r in d][:2])" 2>&1)
  echo "t+$((i*20))s runs: $S"
  case "$S" in *succeeded*|*failed*|*error*) break;; esac
done
echo "--- comments"; curl -s $B/api/issues/$IID/comments | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('comments',[])
for c in d: print((c.get('body') or c.get('content') or '')[:700])" 2>&1 | head -14
echo ST5_DONE
