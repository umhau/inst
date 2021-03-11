#!/bin/bash

# TODO: cmd for whole screen, cmd for current window

tempfile=$(/tmp/screenshot.`date +%s`.png)

maim --bordersize=10 -s "$tempfile" 

filename=$(zenity --file-selection --title='save screenshot' --modal --save --confirm-overwrite --filename="/home/`whoami`/screenshot.`date +%s`.png")

[ -z "$filename" ] && mv "$tempfile" "$filename"
