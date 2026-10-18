#!/bin/bash
exec > ~/pc5.txt 2>&1
B=http://127.0.0.1:3100
curl -s -m 5 -o /tmp/oa.json $B/api/openapi.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/oa.json')); S=d.get('components',{}).get('schemas',{})
def show(path,meth):
    op=d['paths'][path][meth]; rb=op.get('requestBody',{}).get('content',{}).get('application/json',{}).get('schema',{})
    if '$ref' in rb: rb=S[rb['$ref'].split('/')[-1]]
    print(meth.upper(),path,'required:',rb.get('required'),'props:',', '.join(list(rb.get('properties',{}))[:25]))
    for k in ('adapterType',):
        p=rb.get('properties',{}).get(k,{}); 
        if 'enum' in p: print('  adapterType enum:',p['enum'])
for p,m in [('/api/companies','post'),('/api/companies/{companyId}/agents','post'),('/api/companies/{companyId}/agent-hires','post')]:
    try: show(p,m)
    except Exception as e: print('skip',p,e)
PY
echo "--- create company"
curl -s -m 10 -X POST $B/api/companies -H 'content-type: application/json' -d '{"name":"VietUGC HQ","description":"AI workforce that runs the VietUGC / William B. Gold business"}' | cut -c1-300
echo; echo PC5_DONE
