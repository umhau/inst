#!/bin/bash

period='1m'

while :
do 
    # src: https://stackoverflow.com/a/12045412
    files=(/home/`whoami`/system/wallpaper/current/*)
    randompic=`printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`
    
    # src: https://stackoverflow.com/a/27884606
    # wallpaper=`ls -d -1 "/home/`whoami`/system/wallpaper/current/*" | shuf -n1 `
    
    feh --bg-fill "$randompic"
    # feh --randomize --bg-fill /home/`whoami`/system/wallpaper/current/*
    sleep $period
    # --bg-scale, --bg-fill
done

# reason for edits: I dont see a lot of variation in the pictures. bad 
# randomizer?  alternatively, wrong file formats.
