#!/bin/bash
{
echo "== processes"; ps aux | grep -i -E "herald|hermes" | grep -v grep | awk '{print $11,$12,$13,$14}' | cut -c1-150 | sort | uniq -c | sort -rn | head -12
echo "== herald dirs"; ls -d ~/.config/herald* ~/.herald* ~/.local/share/herald* ~/.hermes/herald* 2>/dev/null
echo "== HERMES_HOME used"; for p in $(pgrep -f herald-os | head -3); do tr '\0' '\n' < /proc/$p/environ 2>/dev/null | grep -E "^HERMES" ; done | sort -u
echo "== hermes dirs"; ls -d ~/.hermes* 2>/dev/null; ls ~/.hermes | head -30
echo "== kanban in herald"; D=~/herald/app/herald-os-0.1.0-alpha.4-linux-x64/resources; ls $D | head; (command -v npx >/dev/null && true); grep -rIl -i "kanban" $D 2>/dev/null | head -5
echo "== herald-os-linux"; ls ~/herald/app/*/resources/herald-os-linux | head
echo VC28_DONE
} 2>&1 | tee ~/vc28.txt
