#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/pc2.txt 2>&1
echo "TOP: $(paperclipai --help 2>&1 | awk '/Commands:/{f=1;next} f&&/^  [a-z]/{printf "%s ",$1}')"
for c in company agent; do echo "$c: $(paperclipai $c --help 2>&1 | awk '/Commands:/{f=1;next} f&&/^  [a-z]/{printf "%s ",$1}')"; done
echo "companies: $(paperclipai company list 2>&1 | head -5 | cut -c1-150)"
echo PC2_DONE
