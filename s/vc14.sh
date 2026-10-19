#!/bin/bash
# Telegram wiring for Hermes. Token read with a star per character; stored only in ~/.hermes/.env
UID_TG="$1"
echo
echo "PASTE the Telegram bot token now (Ctrl+Shift+V) once, then press Enter."
TOK=""
while IFS= read -r -s -n1 c </dev/tty; do
  [ -z "$c" ] && break
  TOK="$TOK$c"; printf '*'
done
echo
echo "length: ${#TOK}"
case "$TOK" in [0-9]*:*) ;; *) echo "That does not look like a bot token. Stopping."; exit 1;; esac
[ ${#TOK} -gt 70 ] && { echo "Too long, stopping."; exit 1; }
ME=$(curl -s "https://api.telegram.org/bot$TOK/getMe")
echo "$ME" | grep -q '"ok":true' && echo "token check: OK ($(echo "$ME" | grep -o '"username":"[^"]*"'))" || { echo "token check FAILED"; exit 1; }
[ -f ~/.hermes/.env.bak-before-telegram ] || cp ~/.hermes/.env ~/.hermes/.env.bak-before-telegram
sed -i '/^TELEGRAM_BOT_TOKEN=/d;/^TELEGRAM_ALLOWED_USERS=/d;/^TELEGRAM_HOME_CHANNEL=/d' ~/.hermes/.env
{ echo "TELEGRAM_BOT_TOKEN=$TOK"; echo "TELEGRAM_ALLOWED_USERS=$UID_TG"; echo "TELEGRAM_HOME_CHANNEL=$UID_TG"; } >> ~/.hermes/.env
chmod 600 ~/.hermes/.env
systemctl --user restart hermes-gateway; sleep 8
echo "gateway: $(systemctl --user is-active hermes-gateway)" | tee ~/vc14.txt
curl -s "https://api.telegram.org/bot$TOK/sendMessage" -d chat_id="$UID_TG" -d text="Hermes is wired to Telegram. Say hi." | grep -o '"ok":[a-z]*' | tee -a ~/vc14.txt
journalctl --user -u hermes-gateway -n 15 --no-pager | grep -i telegram | tail -5 | tee -a ~/vc14.txt
echo VC14_DONE | tee -a ~/vc14.txt
