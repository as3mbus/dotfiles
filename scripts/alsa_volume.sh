#!/bin/bash
Vol() 
{
    notmute=$(amixer get Master|\
            sed -e '1,/Mono/d'|\
            awk '{print $6}'|\
            tr '\r\n' ' '|\
            cut -d' ' -f 1)
    if [[ $notmute == "[off]" ]]; then
        echo -n "Mute"
    else 
        volume=$(amixer get Master|\
                sed -e '1,/Mono/d'|\
                awk '{print $5}'|\
                tr '\r\n' ' '|\
                cut -d' ' -f 1|\
                sed -e 's/\[\([0-9]\+%\)\]/\1/'|\
                awk '{printf "%3.0f %", $1}')
        #volume_bar=$(echo $volume | gdbar -h 2 -w 50 -fg orange)
        echo -n "$volume"
    fi
    return
}
Vol
