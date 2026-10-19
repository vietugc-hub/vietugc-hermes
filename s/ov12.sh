#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov12.txt 2>&1
for m in $(ollama ps 2>/dev/null | awk 'NR>1{print $1}'); do ollama stop $m; done
sleep 5
echo "== mem after unload"; free -m | sed -n 1,3p
echo "== top mem"; ps -eo rss,pcpu,comm --sort=-rss | head -7 | awk '{printf "%d MB  cpu %s  %s\n",$1/1024,$2,$3}'
echo "== swap"; swapon --show 2>&1 | head -3
echo OV12_DONE
