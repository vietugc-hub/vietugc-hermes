#!/bin/bash
exec > ~/st3.txt 2>&1
B=http://127.0.0.1:3100
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
curl -s $B/api/companies/$C/heartbeat-runs | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('runs',[])
r=[x for x in d if x.get('status')=='failed'][0]
for k in ('errorCode','error','errorMessage','stderrExcerpt','stdoutExcerpt','resultJson'):
    if r.get(k): print(k,':',str(r[k])[:500])
print('keys',list(r)[:30])"
echo "hermes at: $(command -v hermes) ; $(ls ~/.local/bin | tr '\n' ' ')"
echo ST3_DONE
