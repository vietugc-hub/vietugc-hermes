#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/vietugc-hub/vietugc-hermes/main/s/pcfix.sh -o ~/pcfix.sh
nohup bash ~/pcfix.sh >/dev/null 2>&1 &
echo started
