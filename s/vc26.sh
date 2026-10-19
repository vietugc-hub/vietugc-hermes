#!/bin/bash
{
mkdir -p ~/herald && cd ~/herald
J=$(curl -s https://api.github.com/repos/iamlukethedev/Herald-OS/releases | python3 -c "
import sys,json
r=json.load(sys.stdin)
for rel in r:
    for a in rel['assets']:
        if a['name'].endswith('linux-x64.tar.gz'):
            print(rel['tag_name'],a['browser_download_url'],a['size']); raise SystemExit
")
echo "found: $J"
set -- $J
[ -z "$2" ] && { echo "no tarball found"; echo VC26_DONE; exit; }
echo "size MB: $(( $3 / 1048576 ))"
curl -sL -o herald.tar.gz "$2" && ls -la herald.tar.gz
mkdir -p app && tar -xzf herald.tar.gz -C app && ls app | head
echo "== top-level"; find app -maxdepth 2 | head -25
echo "== setup/readme"; find app -maxdepth 3 -iname "README*" -o -maxdepth 3 -name "herald-os*" | head
echo VC26_DONE
} 2>&1 | tee ~/vc26.txt
