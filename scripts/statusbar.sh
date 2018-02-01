#!/usr/bin/env sh
basedir=$(dirname $0)
source $basedir/lemonbar_conf.sh
source $basedir/resource.sh

#create vertical bar with defined color arg1 and width arg2
VerticalBar(){
    if [ -z "$1" ]; then
        local color=#000000
    else
        local color=$1
    fi
    if [ -z "$2" ]; then
        local width=5
    else
        local width=$2
    fi
    echo -en '%{B'$color'}%{O'$width'}%{B-}'
}
# Home Buttone for dmenu
Home(){
    echo -en "%{A:rofi -show run:}%{O"$itemPadding"}$squareIcon_awesome%{O"$itemPadding"}%{A}"
}
Battery(){
    local capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    echo -en $capacity'%'
}
# CPU usage indicator
CPU() {
# https://stackoverflow.com/questions/9229333/how-to-get-overall-cpu-usage-e-g-57-on-linux
local CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'|sed -e 's/\([0-9]\+\).\+/\1 %/')
echo -n $CPU

}
# bandwidth indicator
# not used yet
Bandwidth() {
# https://github.com/patlux/dotfiles/blob/master/config/lemonbar/blocks/disabled/network-bandwidth.sh
  R1=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
  T1=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
  sleep 1
  R2=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
  T2=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
  TBPS=`expr $T2 - $T1`
  RBPS=`expr $R2 - $R1`
  TKBPS=`expr $TBPS / 1024`
  RKBPS=`expr $RBPS / 1024`

  # rx = downspeed
  # tx = upspeed

  echo "$ICON_UP $RKBPS kB/s $ICON_DOWN $TKBPS kB/s"
}
# active window indicator
ActiveWindow(){
    windowId=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    windowTitle=$(xprop -id $windowId | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
    echo -n $windowTitle
}
# Internet Indicator
# not tested with ethernet because reasons
WIFI(){
    local ethernetStatus=$(cat /sys/class/net/$ethernetInterface/carrier)
    local wifiStatus=$(cat /sys/class/net/$wifiInterface/carrier)
    local text=''
    if [[ "$ethernetStatus" -eq 1 ]];then 
        text=etherneticon
	#open for new idea
    elif [[ "$wifiStatus"==1 ]];then
        local signalStrength=$(iwconfig wlp3s0| grep Link|sed -re 's/.*=([0-9]+\/[0-9]+).*/\1/g'|sed -e 's/\// \/ /'| awk '{print $1 *100 / $3}')
	local SSID=$(iwgetid -r)
	text=$SSID #' '$signalStrength
    else
        text='not connected'
    fi
    echo -n $text
}
# Date Indicator
Date() {
    local date=$(date +'%a, %d %b %Y')
    echo -n "$date"
}
# Time Indicator
Time() {
    local time=$(date +'%H:%M:%S')
    echo -n "$time"
}
# Volume Indicator
Vol() {
    notmute=$(amixer get Master| sed -e '1,/Mono/d'| awk '{print $6}'| tr '\r\n' ' '| cut -d' ' -f 1)
    if [[ $notmute == "[off]" ]]; then
        echo -n "Mute"
    else 
	    volume=$(amixer get Master| sed -e '1,/Mono/d'| awk '{print $5}'| tr '\r\n' ' '| cut -d' ' -f 1| sed -e 's/\[\([0-9]\+%\)\]/\1/')
        #volume_bar=$(echo $volume | gdbar -h 2 -w 50 -fg orange)
        echo -n "$volume"
    fi
    return
}
# Formattinf and printing everything needed
Print () {
	# Active Window Formatting
	echo -en '%{c}%{T3}'
	echo -en $(ActiveWindow)'%{T-}%{O500}'
	# Home Button Formatting
	echo -en '%{l}'
        echo -en '%{O'$itemPadding'}'
	echo -en $(Date)
        echo -en '%{O'$itemPadding'}'
        echo -en $(VerticalBar $mikuPink $borderWidth)


	echo -en '%{r}'
	# CPU Usage Formatting
	echo -en '%{U'$mikuGray'}%{F'$mikuGray'}%{+o}'
	echo -en $(VerticalBar $mikuGray $borderWidth)
	echo -en '%{O'$itemPadding'}'
	echo -en $serverIcon_awesome $(CPU)'%'
	echo -en '%{O10}%{-o)'
	echo -en $(VerticalBar $mikuBlack $itemOffset)
	# Wifi Formatting
	echo -en '%{+o}%{U'$mikuGreen'}%{F'$mikuGreen'}'
	echo -en $(VerticalBar $mikuGreen $borderWidth)'%{O'$itemPadding'}'
	echo -en $wifiIcon_awesome $(WIFI)
	echo -en '%{O'$itemPadding'}%{-o}'
	# volume special formatting
	echo -en '%{U'$mikuGreen'}%{B'$mikuBlack'}%{F'$mikuGray'}'
	echo -en '%{O'$itemOffset'}'
	echo -en $(VerticalBar $mikuPink $borderWidth)'%{O'$itemOffset'}'
	echo -en '%{+u}%{+o}%{O'$itemPadding'}'
	echo -en $soundUpIcon_awesome $(Vol)'%'
	echo -en '%{O'$itemPadding'}%{-u}%{-o}'
	echo -en '%{O'$itemOffset'}'$(VerticalBar $mikuPink $borderWidth)
	echo -en '%{O'$itemOffset'}'
	# Battery formatting
	echo -en '%{U'$mikuGreen'}%{F'$mikuGreen'}'
	echo -en '%{+o}%{O'$itemPadding'}'
	echo -en $batteryIcon_awesome $(Battery)'%'
	echo -en '%{O'$itemPadding'}'$(VerticalBar $mikuGreen $borderWidth)'%{-o}'
	echo -en '%{O'$itemOffset'}'
	# Time formatting
	echo -en '%{U'$mikuGray'}%{F'$mikuGray'}'
	echo -en '%{+o}%{O'$itemPadding'}'
	echo -en $(Time)
	echo -en '%{O'$itemPadding'}'$(VerticalBar $mikuGray $borderWidth)'%{-o}%{B-}%{F-}%{U-}'

}
while true 
do
    sleep 1
    echo "$(Print)" 
done| lemonbar -p -u $borderWidth -U $mikuGreen -g x24 -f "$font_awesome" -f "$font_dejavuSans" -f "$font_dejavuSans_medium" -B $mikuBlack -F $mikuGreen|sh 
