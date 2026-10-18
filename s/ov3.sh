#!/bin/bash
grep -q '^ovi()' ~/.bashrc || echo 'ovi(){ export PATH="$HOME/.local/bin:$PATH"; openviking-server "$@";}' >> ~/.bashrc
echo ok
