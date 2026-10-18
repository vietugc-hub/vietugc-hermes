#!/bin/bash
{ systemctl --user cat paperclipai.service | cut -c1-200; echo ----; journalctl --user -u paperclipai.service -n 20 --no-pager | cut -c1-200; } > ~/pcj.txt 2>&1
echo PCJ_DONE
