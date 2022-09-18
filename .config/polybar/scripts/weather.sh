#!/bin/env bash

# Original source - https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-detailed

get_icon() {
    case $1 in
        01d) ICON="";;
        01n) ICON="";;
        #02d) ICON="";; # This was commented because of below icon
        #02n) ICON="";; # This icon not working correctly
        02d) ICON="";;
        02n) ICON="";;
        03*) ICON="";;
        04*) ICON="";;
        09*) ICON="";;
        10d) ICON="";;
        10n) ICON="";;
        11*) ICON="";;
        13*) ICON="";;
        50*) ICON="";;
        *) ICON="";
    esac

    echo $ICON
}

# Global settings
source ~/.config/polybar/scripts/priv_info.sh #needs two variables, KEY (with the openweather api key) and CITY (with the city key for your city)
UNITS="metric"
SYMBOL="°C"
API="https://api.openweathermap.org/data/2.5"

# Get weather
WEATHER=$(curl -sf "$API/weather?APPID=$KEY&id=$CITY&units=$UNITS")

# Get temp and icon
WEATHER_ICON=$(echo $WEATHER | jq -r ".weather[0].icon")
WEATHER_TEMP=$(echo $WEATHER | jq -r ".main.temp")

# Print weather
printf  "$(get_icon $WEATHER_ICON) %.*f$SYMBOL" 0 $WEATHER_TEMP
