#!/bin/bash

# set screen-off delay, lock the screen, disable-screen-off once unlocked

xset s on                            # turn the screen saver functions on or off
xset +dpms                                 # enables DPMS (Energy Star) features
xset s blank                       # blank the video (if the hardware can do so)
xset s 180    # seconds to wait before blanking screen [300=5m, 180=3m, 600=10m]

# -a is a shim to let i3lock-mm see extra i3lock arguments
# --nofork lets me execute commands once the screen is unlocked
i3lock-mm -i /etc/lockscreen.surf.png -a --nofork

xset s off
xset -dpms
xset -dpms s off
xset s noblank
