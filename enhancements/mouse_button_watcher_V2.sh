#!/bin/bash
# https://unix.stackexchange.com/questions/106736/detect-if-mouse-button-is-pressed-then-invoke-a-script-or-command

MOUSE_ID=$(xinput --list | grep -i -m 1 'mouse' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
MOUSE_ID=11
STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)

while true; do
    sleep 0.2
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
    comm -13 <(echo "$STATE1") <(echo "$STATE2")
    STATE1=$STATE2
done

