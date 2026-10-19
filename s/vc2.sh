#!/bin/bash
# Read-only: how Hermes stores a custom provider + key, where its python lives, tts config. Writes ~/vc2.txt
O=~/vc2.txt
H=~/.hermes/hermes-agent
{
echo "== hermes bin"; which hermes; head -1 "$(which hermes)"
echo "== config custom/tts lines"; grep -n -i -E 'base_url|api_key|custom_providers|^tts|^  provider|edge' ~/.hermes/config.yaml | head -25
echo "== source: custom provider key lookup"; grep -rn -E 'OPENAI_API_KEY|custom_providers|key_env' $H/hermes_cli/*.py 2>/dev/null | head -12
echo "== tts source"; grep -rln -i 'edge_tts' $H --include=*.py 2>/dev/null | head -5
echo "== uv/pip"; which uv pip pip3
echo "== apt ffmpeg candidate"; apt-cache policy ffmpeg 2>/dev/null | head -3
echo "== sudo no-password?"; sudo -n true 2>&1 | head -1
echo DONE
} > $O 2>&1
