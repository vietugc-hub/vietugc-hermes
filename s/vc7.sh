#!/bin/bash
# Read-only: show Hermes fallback chain and any model names mentioned in config. Writes ~/vc7.txt
O=~/vc7.txt
{
echo "== hermes fallback list"; hermes fallback list 2>&1 | head -20
echo "== config fallback lines"; grep -n -i -A12 -E '^fallback' ~/.hermes/config.yaml | grep -v '^[0-9]*-\s*#' | head -30
echo "== models mentioned (free)"; grep -o -E '[a-z0-9._-]+/[a-z0-9._:-]+:free' ~/.hermes/config.yaml | sort -u | head -12
echo VC7_DONE
} > $O 2>&1
cat $O
