#!/bin/bash
# change display settings
# version 2.0 | 3.1.2020 | um.hau | um.hau@outlook.com

## TODO ## ----------------------------------------------------------------- ##

# [ ] add flexibility for VGA1 vs VGA-1 back in. (or detect that separately)

## VARIABLES ## ------------------------------------------------------------ ##

display_list=($(xrandr --prop | awk '
    !/^[ \t]/ { if (output && hex) print output; output=$1; hex="" }
    /ConnectorType:/ {conn=$2}
    /[:.]/ && h { h=0 } ;  h {sub(/[ \t]+/, ""); hex = hex $0}
    /EDID.*:/ {h=1}' | sort ))

echo "${display_list[@]}"
display_count=${#display_list[@]}
echo "display count = $display_count"
exit


if [ $display_count == '3' ]; then

    echo "searching for configurations with 3 monitors"

    if 




SC=/network/settings/s/disp                                     # script source

if xrandr | grep --quiet VGA-1;then echo "names have dashes"; dash="-";fi 

rm -rf /tmp/xrandr.output; xrandr -q > /tmp/xrandr.output
DP() { 
	type=${1::-1}; 
	number=`echo "$1" | tail -c 2`
	[ "`cat /tmp/xrandr.output | grep "$type$dash$number connected"| wc -l`" == "1" ] 
	echo "$1=$type=$number"
}


## COMMAND LINE OPTIONS ## ------------------------------------------------- ##

if [ "$1" == 'u' ];then echo "updating";sudo install "$SC" /usr/local/bin/;exit
elif [ "$1" == 'manual' ]; then arandr & exit
elif [ "$1" == 'internal' ]; then
    xrandr --output VGA1 --off --output HDMI3 --off && xrandr LVDS1 --mode 1366x768
    sleep 5; exit
elif [ "$1" == 'hdpi' ]; then xrandr --dpi 96; exit
fi

## DETECT AND ADJUST DISPLAYS ## ------------------------------------------- ##



# only the laptop screen is connected
if DP LVDS1 && ! DP DP1 && ! DP DP2 && ! DP DP3 && ! DP VGA1 && ! DP VGA2 && ! DP HDMI1 && ! DP HDMI2; then
    echo 1
#    echo "no external monitors detected; enabling internal display"
#    xrandr --output VGA1 --off --output HDMI3 --off && \
#    xrandr --output LVDS1 --mode 1366x768 && \
#    xrandr -s 0    
#
#    # arandr output - maybe a preferable alternative
#    # xrandr --output LVDS1 --mode 1366x768 --pos 0x0 --rotate normal \ 
#    #     --output DP1 --off --output DP2 --off --output HDMI1 --off \
#    #     --output HDMI2 --off --output VGA1 --off --output VIRTUAL1 --off
#    
#    xrandr --dpi 96                 # https://www.reddit.com/r/i3wm/comments/49jc9b

elif DP HDMZI3 && DP VGA1; then
    echo 2
#    # this is tricky: at no point can 3 screens be active, but for safety I 
#    # don't want to disable all screens simultaneously.
#    echo "configuring detected VGA1 and HDMI3 and disabling internal LVDS1."
#    xrandr -s 0 && \
#    xrandr --output VGA1 --mode 1920x1080 --right-of LVDS1 --output LVDS1 \
#        --mode 1366x768 && \
#    xrandr --output LVDS1 --off && \
#    xrandr --output VGA1 --mode 1920x1080 --primary  --output HDMI3 \
#        --mode 1680x1050  --left-of VGA1 --output LVDS1 --off && \
#    xrandr --dpi 100

# external VGA
elif DP LVDZS1 && DP VGA1 && ! DP DP1 && ! DP DP2 && ! DP VGA2 && ! DP HDMI1 && ! DP HDMI2; then
    echo 3
#    echo "configuring detected VGA1 display alongside internal display"
#    xrandr -s 0 && \
#    xrandr --output VGA1 --mode 1920x1080 --right-of LVDS1 --output LVDS1 --mode 1366x768
#    
#    xrandr --dpi 96                 # https://www.reddit.com/r/i3wm/comments/49jc9b

# my desktop is using dashes in the display hardware names. :(
elif DP VGA-1 && DP 'DP-1' && ! HDMI-1 && DP 'DP-2' && ! HDMI-1; then

echo 'desktop detected'
	
	xrandr --dpi 80

else
    echo 5
    # unknown external monitors - open arandr
#    arandr &
    exit

fi

# reset wallpaper :)
files=(/home/`whoami`/system/wallpaper/current/*)
randompic=`printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`
feh --bg-fill "$randompic"

