#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar() {
	killall -q polybar
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	DP2=$(xrandr -q | grep "DP-2 connected")
	VGA1=$(xrandr -q | grep "VGA-1 connected")

	if [[ "$style" == "hack" || "$style" == "cuts" ]]; then
		polybar -q top -c "$dir/$style/config.ini" &
		polybar -q bottom -c "$dir/$style/config.ini" &
	elif [[ "$style" == "pwidgets" ]]; then
		bash "$dir"/pwidgets/launch.sh --main
	else
		if [ -n "$DP2" ] || [ -n "$VGA1" ]; then
			# Monitores externos: usar config personalizada
			[ -n "$DP2" ] && MONITOR=DP-2 polybar -q main -c "$dir/$style/config.ini" &
			[ -n "$VGA1" ] && MONITOR=VGA-1 polybar -q secondary -c "$dir/$style/config.ini" &
		else
			# Solo notebook: usar config original del repo
			MONITOR=LVDS-1 polybar -q main -c "$dir/$style/config.ini" &
		fi
	fi
}

if [[ "$1" == "--material" ]]; then style="material"; launch_bar
elif [[ "$1" == "--shades" ]]; then style="shades"; launch_bar
elif [[ "$1" == "--hack" ]]; then style="hack"; launch_bar
elif [[ "$1" == "--docky" ]]; then style="docky"; launch_bar
elif [[ "$1" == "--cuts" ]]; then style="cuts"; launch_bar
elif [[ "$1" == "--shapes" ]]; then style="shapes"; launch_bar
elif [[ "$1" == "--grayblocks" ]]; then style="grayblocks"; launch_bar
elif [[ "$1" == "--blocks" ]]; then style="blocks"; launch_bar
elif [[ "$1" == "--colorblocks" ]]; then style="colorblocks"; launch_bar
elif [[ "$1" == "--forest" ]]; then style="forest"; launch_bar
elif [[ "$1" == "--pwidgets" ]]; then style="pwidgets"; launch_bar
elif [[ "$1" == "--panels" ]]; then style="panels"; launch_bar
else
	cat <<- EOF
	Usage : launch.sh --theme
	Available Themes :
	--blocks    --colorblocks    --cuts      --docky
	--forest    --grayblocks     --hack      --material
	--panels    --pwidgets       --shades    --shapes
	EOF
fi
