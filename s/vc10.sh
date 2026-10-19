#!/bin/bash
# Read-only: find Hermes' python and the command that installs voice extras. Writes ~/vc10.txt
O=~/vc10.txt
H=~/.hermes/hermes-agent
{
echo "== hermes wrapper"; cat "$(which hermes)" | head -12
echo "== venv dirs"; ls -d $H/.venv* $H/venv* $H/.*venv* 2>/dev/null; ls $H | head -30 | tr '\n' ' '; echo
echo "== find python with hermes_cli"; for P in $(ls $H/*/bin/python $H/.*/bin/python 2>/dev/null); do echo "$P: $($P -c 'import hermes_cli;print("hermes_cli ok")' 2>&1 | tail -1)"; done
echo "== help: extras/tools/setup"; hermes --help 2>&1 | grep -i -E 'extra|install|tools|setup|voice|doctor' | head -10
echo VC10_DONE
} > $O 2>&1
cat $O
