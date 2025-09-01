#! /usr/bin/env zsh
# fix overscan (for when using old HDMI TV as a monitor)
xrandr --output hdmi-a-0 --set underscan on & xrandr --output hdmi-a-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40
