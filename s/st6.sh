#!/bin/bash
exec > ~/st6.txt 2>&1
B=http://127.0.0.1:3100
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
for i in 1 2 3 4 5 6; do
  R=$(curl -s $B/api/companies/$C/heartbeat-runs | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('runs',[])
d=sorted(d,key=lambda x:x.get('startedAt') or '',reverse=True); r=d[0]
print(r.get('status'),r.get('errorCode') or '','|',str(r.get('error') or '')[:150],'|',str(r.get('stdoutExcerpt') or '')[-500:].replace('\n',' / '))")
  echo "poll $i: $R"; case "$R" in running*|queued*) sleep 20;; *) break;; esac
done
echo "--- issues + comments"
curl -s $B/api/companies/$C/issues | python3 -c "
import sys,json,urllib.request
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('issues',[])
for i in d[:3]:
    print('ISSUE',i.get('identifier'),i.get('status'),i.get('title'))
    try:
        cs=json.load(urllib.request.urlopen('http://127.0.0.1:3100/api/issues/%s/comments'%i['id'])); cs=cs if isinstance(cs,list) else cs.get('comments',[])
        for c in cs[-2:]: print('  >',(c.get('body') or '')[:600].replace('\n',' / '))
    except Exception as e: print('  err',e)"
echo ST6_DONE
