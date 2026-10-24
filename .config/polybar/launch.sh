#!/bin/env bash

# Terminate already running bars (graceful)
killall -q polybar

# Wait up to ~3s for a clean shutdown, then force-kill any straggler.
# A wedged polybar (e.g. stuck in an i3-socket reconnect loop) can ignore
# SIGTERM; without this fallback the old loop would spin here forever and
# the bars below would never launch.
for _ in $(seq 1 6); do
	pgrep -u "$UID" -x polybar >/dev/null || break
	sleep 0.5
done
pgrep -u "$UID" -x polybar >/dev/null && killall -q -9 polybar

# Launch one bar per connected monitor.
# The pomodoro timer (polypomo) binds a single socket, so it may live on only
# one bar: prefer HDMI-1 when it's connected, otherwise the sole/first monitor.
mapfile -t connected < <(xrandr --query | awk '/ connected/ {print $1}')

pomo_monitor="${connected[0]}"
for m in "${connected[@]}"; do
	[[ "$m" == "HDMI-1" ]] && pomo_monitor="HDMI-1" && break
done

for m in "${connected[@]}"; do
	if [[ "$m" == "$pomo_monitor" ]]; then bar=bottom-pomo; else bar=bottom; fi
	MONITOR="$m" polybar "$bar" &
done
