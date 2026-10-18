#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov1.txt 2>&1
echo "sudo-n: $(sudo -n true 2>&1 && echo yes || echo no)  ollama: $(command -v ollama || echo none)  py: $(python3 --version)"
uv tool install --python 3.12 --upgrade openviking 2>&1 | tail -3
which openviking-server
openviking-server --help 2>&1 | head -25 | cut -c1-150
echo "--- init help"; openviking-server init --help 2>&1 | head -30 | cut -c1-150
echo OV1_DONE
