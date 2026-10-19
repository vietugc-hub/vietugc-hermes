#!/bin/bash
# Read-only: hermes config set help, current model block, and Hermes' own Discord voice doctor. Writes ~/vc3.txt
O=~/vc3.txt
H=~/.hermes/hermes-agent
{
echo "== config set help"; hermes config set --help 2>&1 | head -6
echo "== model block (comments hidden)"; awk '/^model:/{f=1;print;next} f&&/^[A-Za-z_]/{f=0} f' ~/.hermes/config.yaml | grep -v '^ *#' | grep -v '^$' | head -12
echo "== voice doctor"; PY=$(head -1 "$(which hermes)" | sed 's/^#!//'); echo "py=$PY"
$PY $H/scripts/discord-voice-doctor.py 2>&1 | tail -30
echo VC3_DONE
} > $O 2>&1
