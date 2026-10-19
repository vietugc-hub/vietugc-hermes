#!/bin/bash
D=~/herald/app/herald-os-0.1.0-alpha.4-linux-x64
cd $D
echo "== bin help"; ls resources/herald-os-linux resources/herald-os-bridge 2>&1 | head -12
export DISPLAY=${DISPLAY:-:10.0}
nohup ./herald-os --no-sandbox > ~/herald/run.log 2>&1 &
sleep 12
echo "== process"; pgrep -af herald-os | head -3 | cut -c1-120
echo "== log"; tail -12 ~/herald/run.log | cut -c1-200
echo VC27_DONE
