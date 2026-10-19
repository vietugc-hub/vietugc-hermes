#!/bin/bash
# Put the previous primary (poolside/laguna-s-2.1:free) back as fallback #1, keep the other six in the same order. Writes ~/vc8.txt
O=~/vc8.txt
{
C=~/.hermes/config.yaml
cp $C ~/.hermes/config.yaml.bak-before-laguna-s
python3 - <<'PY'
import re,os
p=os.path.expanduser('~/.hermes/config.yaml')
s=open(p).read()
m=re.search(r'^fallback_providers:\s*(\[.*\])\s*$',s,re.M)
assert m, 'fallback_providers line not found'
line=m.group(1)
new='[{provider: nous, model: "poolside/laguna-s-2.1:free"}, '+line[1:]
if 'laguna-s-2.1' in line:
    print('already present'); raise SystemExit
s=s[:m.start(1)]+new+s[m.end(1):]
open(p,'w').write(s)
print('updated')
PY
echo "== hermes fallback list"; hermes fallback list 2>&1 | head -16
systemctl --user restart hermes-gateway; sleep 6; echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo VC8_DONE
} > $O 2>&1
cat $O
