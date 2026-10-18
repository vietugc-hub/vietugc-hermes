#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/osb5.txt 2>&1
mkdir -p ~/osb-test && cd ~/osb-test
[ -d .venv ] || uv venv -q
uv pip install -q -p .venv opensandbox 2>&1 | tail -2
export OPEN_SANDBOX_API_KEY="$(cat ~/.osb-key)" OPEN_SANDBOX_DOMAIN="localhost:8080"
cat > t.py <<'PY'
import asyncio, os
from opensandbox import Sandbox
async def main():
    try:
        from opensandbox.config import ConnectionConfig
        cfg = ConnectionConfig(domain=os.environ["OPEN_SANDBOX_DOMAIN"], api_key=os.environ["OPEN_SANDBOX_API_KEY"], protocol="http")
        sb = await Sandbox.create("python:3.12-slim", connection_config=cfg)
    except ImportError:
        sb = await Sandbox.create("python:3.12-slim")
    try:
        ex = await sb.commands.run("python -c 'print(6*7)'")
        print("SANDBOX OUTPUT:", ex.logs.stdout[0].text)
    finally:
        await sb.kill() if hasattr(sb,"kill") else await sb.destroy()
asyncio.run(main())
PY
timeout 240 .venv/bin/python t.py 2>&1 | tail -8 | cut -c1-200
echo OSB5_DONE
