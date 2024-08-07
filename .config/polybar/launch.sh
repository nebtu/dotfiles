#!/bin/env bash

# Terminate already running bars
killall -q polybar

# Wait until bars have been terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
MONITOR=eDP-1 polybar bottom &
MONITOR=HDMI-1 polybar bottom &
