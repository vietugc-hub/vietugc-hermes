#!/bin/bash
# One-time root fix: when the remote desktop is closed, end the session cleanly so the next login never gets a stuck session.
sudo bash -c '
f=/etc/xrdp/sesman.ini
cp -n $f $f.bak
sed -i -E "s/^;?\s*KillDisconnected=.*/KillDisconnected=true/" $f
grep -q "^KillDisconnected=true" $f || sed -i "0,/^\[Sessions\]/s//[Sessions]\nKillDisconnected=true/" $f
grep -n "^KillDisconnected" $f
' > ~/rootfix.txt 2>&1
cat ~/rootfix.txt; echo ROOTFIX_DONE
