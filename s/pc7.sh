#!/bin/bash
exec > ~/pc7.txt 2>&1
B=http://127.0.0.1:3100
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
curl -s -m 10 -X POST $B/api/companies/$C/agents -H 'content-type: application/json' -d '{"name":"Stack Expert","role":"engineer","title":"Stack Expert","capabilities":"Knows the whole VietUGC HQ stack (Hermes Agent, Paperclip, Alibaba OpenSandbox, OpenViking, Docker, Ollama): what each is for, why it is here, how they connect, how to operate and fix them. Keeps the docs in the Linux-HQ repo current.","adapterType":"hermes_local","adapterConfig":{}}' | cut -c1-400
echo
curl -s $B/api/openapi.json | python3 -c "
import sys,json
d=json.load(sys.stdin)
for p,m in d['paths'].items():
    if 'instruction' in p: print(' '.join(x.upper() for x in m if x in('get','post','put','patch','delete')),p)"
echo PC7_DONE
