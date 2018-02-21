#!/bin/bash
Battery()
{
    local capacity=$(\
        cat /sys/class/power_supply/BAT0/capacity|\
        awk '{printf "%3.0f %", $1}')
    echo -en "$capacity"
}
Battery
