#!/bin/bash
exec > ~/pc6.txt 2>&1
B=http://127.0.0.1:3100
curl -s -m 8 $B/api/adapters | python3 -c "
import sys,json
d=json.load(sys.stdin); d=d if isinstance(d,list) else d.get('adapters',d)
print([ (a.get('type'),a.get('label') or a.get('name')) for a in d])" 2>&1 | cut -c1-600
C=$(curl -s $B/api/companies | python3 -c "import sys,json;print(json.load(sys.stdin)[0]['id'])")
echo "company $C"
curl -s -m 8 $B/api/companies/$C/adapters/hermes_local/config-schema 2>&1 | cut -c1-500
echo; echo PC6_DONE
