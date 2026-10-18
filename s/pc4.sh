#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/pc4.txt 2>&1
for u in api/openapi.json api/openapi openapi.json api/docs; do c=$(curl -s -m 5 -o /tmp/oa.json -w '%{http_code}' http://127.0.0.1:3100/$u); echo "$u: $c"; [ "$c" = 200 ] && break; done
python3 - <<'PY'
import json
try:
    d=json.load(open('/tmp/oa.json'))
    for p,m in d.get('paths',{}).items():
        if any(k in p for k in ('compan','agent','adapter')) and p.count('{')<=1: print(' '.join(x.upper() for x in m if x in('get','post','put','patch')), p)
except Exception as e: print("noparse",e)
PY
echo "companies: $(curl -s -m 5 http://127.0.0.1:3100/api/companies | cut -c1-150)"
echo PC4_DONE
