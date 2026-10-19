#!/bin/bash
{
cd ~/.hermes/hermes-agent/tools
grep -n -E "get\(.(provider|model|local|language|enabled)|DEFAULT_.*MODEL|stt_config|\"stt\"" transcription_common.py transcription_local.py transcription_tools.py | head -30 | cut -c1-190
echo VC20_DONE
} 2>&1 | tee ~/vc20.txt
