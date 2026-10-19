#!/bin/bash
{
H=~/.hermes/hermes-agent/.hermes/bin/hermes
echo "== kanban"; $H kanban --help 2>&1 | head -12
echo "== boards"; $H kanban boards list 2>&1 | head -6
echo "== dashboard listening?"; (ss -ltn | grep -E ":9119" || echo "no, port 9119 not running")
echo "== dashboard help"; $H dashboard --help 2>&1 | head -12
echo VC25_DONE
} 2>&1 | tee ~/vc25.txt
