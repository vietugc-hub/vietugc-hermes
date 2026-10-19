#!/bin/bash
exec > ~/st8.txt 2>&1
B=http://127.0.0.1:3100
systemctl --user restart paperclipai; sleep 25
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
A=$(curl -s $B/api/companies/$C/agents | python3 -c "import sys,json;d=json.load(sys.stdin);print([a['id'] for a in d if a['name']=='Stack Expert'][0])")
echo "adapterConfig before: $(curl -s $B/api/agents/$A | python3 -c "import sys,json;print(json.load(sys.stdin).get('adapterConfig'))")"
echo "patch: $(curl -s -X PATCH $B/api/agents/$A -H 'content-type: application/json' -d '{"adapterConfig":{"model":"poolside/laguna-s-2.1:free","provider":"nous"}}' | python3 -c "import sys,json;print(json.load(sys.stdin).get('adapterConfig'))" 2>&1 | cut -c1-200)"
T=$(date +%H%M%S)
I=$(curl -s -X POST $B/api/companies/$C/issues -H 'content-type: application/json' -d "{\"title\":\"Stack check $T\",\"description\":\"Using only your instructions, answer in 6 short lines: the four tools and what each is for; what Docker and Ollama are for; where status is kept. Post your answer as a comment on this task.\",\"assigneeAgentId\":\"$A\"}")
IID=$(echo $I | python3 -c "import sys,json;print(json.load(sys.stdin)['id'])")
curl -s -m 15 -X POST $B/api/agents/$A/wakeup -H 'content-type: application/json' -d "{\"reason\":\"retest\",\"issueId\":\"$IID\"}" >/dev/null
for i in 1 2 3 4 5 6 7 8 9; do sleep 20
  R=$(curl -s $B/api/companies/$C/heartbeat-runs | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('runs',[])
d=sorted(d,key=lambda x:x.get('startedAt') or '',reverse=True); r=d[0]
print(r.get('status'),r.get('errorCode') or '','|',str(r.get('error') or '')[:150])")
  echo "poll $i: $R"; case "$R" in running*|queued*|scheduled*) ;; *) break;; esac
done
echo "--- comments"
curl -s $B/api/issues/$IID/comments | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('comments',[])
for c in d[-2:]: print((c.get('body') or '')[:900].replace('\n',' / '))"
echo ST8_DONE
