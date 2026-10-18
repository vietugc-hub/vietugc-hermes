#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov2.txt 2>&1
mkdir -p ~/.local/ollama && cd ~/.local/ollama
if [ ! -x bin/ollama ]; then
  curl -fsSL -o o.tgz https://ollama.com/download/ollama-linux-amd64.tgz && tar -xzf o.tgz 2>&1 | tail -2
  if [ ! -x bin/ollama ]; then
    curl -fsSL -o o.zst https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tar.zst && uv run --with zstandard python -c "import zstandard,tarfile,io;d=zstandard.ZstdDecompressor().stream_reader(open('o.zst','rb'));tarfile.open(fileobj=d,mode='r|').extractall('.')"
  fi
fi
ls -la bin/ollama lib 2>&1 | head -4
ln -sf ~/.local/ollama/bin/ollama ~/.local/bin/ollama
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/ollama.service <<U
[Unit]
Description=Ollama local models (loopback)
[Service]
ExecStart=$HOME/.local/ollama/bin/ollama serve
Environment=OLLAMA_HOST=127.0.0.1:11434 OLLAMA_KEEP_ALIVE=5m
Restart=on-failure
[Install]
WantedBy=default.target
U
systemctl --user daemon-reload; systemctl --user enable --now ollama; sleep 6
echo "ollama: $(systemctl --user is-active ollama) $(ollama --version 2>&1 | tail -1)"
echo OV2_DONE
