#!/bin/bash
H=~/.hermes/hermes-agent/.hermes/bin/hermes
echo "== school site"; curl -s -o /dev/null -w "http %{http_code} %{url_effective}\n" -L --max-time 15 https://school.kynaenglish.com/
curl -s -L --max-time 15 https://school.kynaenglish.com/ | grep -io "<title>[^<]*" | head -1
echo "== profiles"; $H profile list 2>&1 | head -12
echo "== browser tools"; $H tools list 2>&1 | grep -i -E "browser|web|vision|terminal|file" | head -8
echo "== playwright/chromium on server"; (command -v chromium chromium-browser google-chrome 2>/dev/null; ls ~/.cache/ms-playwright 2>/dev/null) | head -4
echo VC31_DONE
