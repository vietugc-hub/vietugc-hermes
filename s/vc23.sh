#!/bin/bash
{
UV=~/.local/bin/uv
P=$(ls -d ~/.hermes/installs/*/environments/*/venv | head -1)
"$P/bin/python" -c "import av,faster_whisper;print('av',av.__version__,av.__file__);print('fw',faster_whisper.__version__)"
"$UV" pip list --python "$P/bin/python" 2>/dev/null | grep -i -E "^av |faster|ctranslate|onnx"
"$UV" pip install -U --python "$P/bin/python" "av>=13" 2>&1 | tail -4
"$P/bin/python" -c "import av;print('av now',av.__version__)"
echo VC23_DONE
} 2>&1 | tee ~/vc23.txt
