#!/bin/bash
exec > ~/st4.txt 2>&1
U=~/.config/systemd/user/paperclipai.service
cp -n $U $U.bak
grep -n -E "^(Environment|ExecStart)" $U | cut -c1-160
if grep -q '^Environment=PATH=' $U; then sed -i -E "s|^Environment=PATH=|Environment=PATH=$HOME/.local/bin:|" $U
else sed -i "0,/^\[Service\]/s||[Service]\nEnvironment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin|" $U; fi
systemctl --user daemon-reload; systemctl --user restart paperclipai; sleep 25
echo "paperclip: $(systemctl --user is-active paperclipai)  api: $(curl -s -m 5 -o /dev/null -w '%{http_code}' http://127.0.0.1:3100/api/health)"
grep -n '^Environment=PATH' $U | cut -c1-160
echo ST4_DONE
