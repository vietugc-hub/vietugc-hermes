#!/bin/bash
exec > ~/st7.txt 2>&1
ps -eo pid,etime,pcpu,args | grep -E "hermes" | grep -v grep | cut -c1-150 | head -6
L=$(find ~/.paperclip -name "*.ndjson" -o -name "*.log" -newermt "-20 minutes" 2>/dev/null | grep -i -E "run|heartbeat" | head -3)
echo "logs: $L"
for f in $L; do echo "== $f"; tail -c 700 "$f" | tr '\n' ' ' | cut -c1-700; echo; done
echo ST7_DONE
