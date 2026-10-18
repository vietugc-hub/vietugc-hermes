#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/pc3.txt 2>&1
echo "== company create"; paperclipai company create --help 2>&1 | grep -v '^$' | cut -c1-125
echo "== agent create"; paperclipai agent create --help 2>&1 | grep -v '^$' | cut -c1-125
echo "== adapters"; paperclipai adapter --help 2>&1 | grep -v '^$' | cut -c1-125 | head -12
echo PC3_DONE
