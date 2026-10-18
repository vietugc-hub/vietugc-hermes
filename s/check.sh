#!/bin/bash
echo "paperclip http: $(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3100/)"
echo "paperclip health: $(curl -s http://127.0.0.1:3100/api/health | cut -c1-150)"
echo "listening: $(ss -ltn | awk 'NR>1{print $4}' | grep -E ':(3100|3101|8080|1933|54329)$' | tr '\n' ' ')"
echo "--- log tail"; tail -n 6 ~/paperclip.log | cut -c1-160
echo "mem: $(free -h | awk 'NR==2{print $3"/"$2}')"
