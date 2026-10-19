#!/bin/bash
echo "== stt config"; grep -n -A6 "^stt:" ~/.hermes/config.yaml
echo "== journal stt"; journalctl --user -u hermes-gateway --since "2 hours ago" --no-pager | grep -iE "transcri|whisper|stt|vosk" | tail -12 | cut -c1-230
echo "== self-made skill"; find ~/.hermes -ipath "*audio-transcription*" -maxdepth 5 2>/dev/null | head; grep -il vosk -r ~/.hermes/skills ~/.hermes/cache/scratch 2>/dev/null | head -3
echo "== vosk installed?"; pip list 2>/dev/null | grep -i vosk; ls ~/.cache/vosk ~/vosk* 2>/dev/null | head -3
echo VC29_DONE
