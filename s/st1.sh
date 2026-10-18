#!/bin/bash
exec > ~/st1.txt 2>&1
B=http://127.0.0.1:3100
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
A=$(curl -s $B/api/companies/$C/agents | python3 -c "import sys,json;d=json.load(sys.stdin);print([a['id'] for a in d if a['name']=='Stack Expert'][0])")
curl -s $B/api/openapi.json | python3 -c "
import sys,json
d=json.load(sys.stdin)
for p,m in d['paths'].items():
    if ('heartbeat' in p or 'wakeup' in p or '/runs' in p or p.endswith('/issues')) and ('agents' in p or 'companies' in p) and p.count('{')<=2: print(' '.join(x.upper() for x in m if x in('get','post')),p)" | head -14
echo "--- test env"; curl -s -m 60 -X POST $B/api/agents/$A/adapter-test -H 'content-type: application/json' -d '{}' | cut -c1-300
echo; echo ST1_DONE
