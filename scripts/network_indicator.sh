#!/bin/bash
basedir=$(dirname $0)
source $basedir/config.sh
# Internet Indicator
# not tested with ethernet because reasons
Network()
{
    local ethernetStatus=$(\
        cat /sys/class/net/$ethernetInterface/carrier)
    local wifiStatus=$(\
        cat /sys/class/net/$wifiInterface/carrier)
    local text=''
    if [[ "$ethernetStatus" -eq 1 ]];then 
        text=etherneticon
	#open for new idea
    elif [[ "$wifiStatus"==1 ]];then
        local signalStrength=$(\
            iwconfig wlp3s0|\
            grep Link|\
            sed -re 's/.*=([0-9]+\/[0-9]+).*/\1/g'|\
            sed -e 's/\// \/ /'|\
            awk '{print $1 *100 / $3}')
        local SSID=$(iwgetid -r)
        text=$SSID #' '$signalStrength
    else
        text='not connected'
    fi
    if  [[ $1 = "-i" ]]; then
        printf "　$text" 
    else
        printf "%s" $text
    fi
}
Network $1
