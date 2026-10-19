#!/bin/bash
# Restart the Hermes gateway so Discord uses the new brain, then show a full one-shot answer. Writes ~/vc6.txt
O=~/vc6.txt
{
systemctl --user restart hermes-gateway; sleep 8
echo "gateway: $(systemctl --user is-active hermes-gateway)"
echo "== one-shot answer"
timeout 120 hermes chat -q "In one short sentence, say which model you are and say READY." 2>&1 | grep -v '^$' | grep -v -i 'session\|duration\|messages\|resume' | tail -6
echo "== gateway log (model/provider lines)"
journalctl --user -u hermes-gateway --since "2 minutes ago" --no-pager 2>/dev/null | grep -i -E 'model|provider|error|connected|discord' | tail -6 | cut -c1-160
echo VC6_DONE
} > $O 2>&1
cat $O
