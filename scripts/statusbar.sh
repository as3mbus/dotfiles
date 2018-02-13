#!/usr/bin/bash
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
    local capacity=$(\
        cat /sys/class/power_supply/BAT0/capacity|\
        awk '{printf "%3.0f %", $1}')
    echo -en "$capacity"
}
# CPU usage indicator
CPU() {
# https://stackoverflow.com/questions/9229333/how-to-get-overall-cpu-usage-e-g-57-on-linux
    local CPU=$(\
        awk '{u=$2+$4; t=$2+$4+$5;\
            if (NR==1)\
            {\
                u1=u;\
                t1=t;\
            }\
            else\
                 printf "%3.0f %", ($2+$4-u1) * 100 / (t-t1) ;\
        }'\
        <(grep 'cpu ' /proc/stat)\
        <(sleep 1;\
            grep 'cpu ' /proc/stat))
    echo -n "$CPU"

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
    local windowId=$(\
        xprop -root |\
        awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    local windowTitle=$(\
        xprop -id $windowId |\
        awk '/_NET_WM_NAME/{$1=$2="";print}' |\
        cut -d'"' -f2)
    echo -n $windowTitle
}
# Internet Indicator
# not tested with ethernet because reasons
WIFI(){
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
# Formattinf and printing everything needed
Print () 
{
local cpu=$(CPU)
# Active Window Formatting
# echo -en '%{c}%{T3}'
# echo -en $(ActiveWindow)'%{T-}%{O350}'
# Home Button Formatting
echo -en \
"\
%{l}\
%{O$itemPadding}\
$(Date)\
%{O$itemPadding}\
$(VerticalBar $mikuPink $borderWidth)\
%{r}"
# CPU Usage Formatting
echo -en \
"%{U$mikuGray}%{F$mikuGray}%{+o}"\
"$(VerticalBar $mikuGray $borderWidth)"\
"%{O$itemPadding}"\
"$serverIcon_awesome $cpu%"\
"%{O$itemPadding}%{-o}"\
"%{O$itemOffset}"
# Wifi Formatting
echo -en \
"%{+o}%{U$mikuGreen}%{F$mikuGreen}"\
"$(VerticalBar $mikuGreen $borderWidth)"\
"%{O$itemPadding}"\
"$wifiIcon_awesome $(WIFI)"\
"%{O$itemPadding}%{-o}"\
"%{O$itemOffset}"
# volume special formatting
echo -en \
"%{U$mikuGreen}%{B$mikuBlack}%{F$mikuGray}"\
"$(VerticalBar $mikuPink $borderWidth)"\
"%{O$itemOffset}"\
"%{+u}%{+o}%{O$itemPadding}"\
"$soundUpIcon_awesome $(Vol)%"\
"%{O$itemPadding}%{-u}%{-o}"\
"%{O$itemOffset}"\
"$(VerticalBar $mikuPink $borderWidth)"\
"%{O$itemOffset}"
	# Battery formatting
echo -en \
"%{U$mikuGreen}%{F$mikuGreen}"\
"%{+o}%{O$itemPadding}"\
"$batteryIcon_awesome $(Battery)%"\
"%{O$itemPadding}"\
"$(VerticalBar $mikuGreen $borderWidth)"\
"%{-o}"\
"%{O$itemOffset}"
	# Time formatting
echo -en \
"%{U$mikuGray}%{F$mikuGray}"\
"%{+o}%{O$itemPadding}"\
"$(Time)"\
"%{O$itemPadding}"\
"$(VerticalBar $mikuGray $borderWidth)"\
"%{-o}%{B-}%{F-}%{U-}"

}
while true 
do
    echo "$(Print)" 
done|\
    lemonbar -p \
        -u $borderWidth\
        -U $mikuGreen\
        -g x24\
        -f "$font_awesome"\
        -f "$font_zevvPeep"\
        -f "$font_zevvPeep"\
        -B $mikuBlack\
        -F $mikuGreen|\
    sh 
