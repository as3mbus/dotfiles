#!/usr/bin/bash
basedir=$(dirname $0)
source $basedir/config.sh
source $basedir/resource.sh
source $basedir/battery.sh
source $basedir/alsa_volume.sh
source $basedir/cpu_usage.sh
source $basedir/network_indicator.sh
#create vertical bar with defined color arg1 and width arg2
VerticalBar()
{
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
Home()
{
    echo -en "%{A:rofi -show run:}%{O"$itemPadding"}$squareIcon_awesome%{O"$itemPadding"}%{A}"
}
# bandwidth indicator
# not used yet
Bandwidth() 
{
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
ActiveWindow()
{
    local windowId=$(\
        xprop -root |\
        awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    local windowTitle=$(\
        xprop -id $windowId |\
        awk '/_NET_WM_NAME/{$1=$2="";print}' |\
        cut -d'"' -f2)
    echo -n $windowTitle
}
# Formatting and printing everything needed
Print () 
{
local cpu=$(CPU)
# Active Window Formatting
# echo -en '%{c}%{T3}'
# echo -en $(ActiveWindow)'%{T-}%{O350}'
echo -en \
"\
%{S0}\
%{l}\
%{O$itemPadding}\
$(date +'%a, %d %b %Y')\
%{O$itemPadding}\
$(VerticalBar $mikuPink $borderWidth)\
%{r}"
    # CPU Usage Formatting
echo -en \
"%{U$mikuGray}%{F$mikuGray}%{+o}"\
"$(VerticalBar $mikuGray $borderWidth)"\
"%{O$itemPadding}"\
"$cpuIcon_siji $cpu%"\
"%{O$itemPadding}%{-o}"\
"%{O$itemOffset}"
    # Network Formatting
echo -en \
"%{+o}%{U$mikuGreen}%{F$mikuGreen}"\
"$(VerticalBar $mikuGreen $borderWidth)"\
"%{O$itemPadding}"\
"$networkIcon_siji $(Network)"\
"%{O$itemPadding}%{-o}"\
"%{O$itemOffset}"
    # volume special formatting
echo -en \
"%{U$mikuGreen}%{B$mikuBlack}%{F$mikuGray}"\
"$(VerticalBar $mikuPink $borderWidth)"\
"%{O$itemOffset}"\
"%{+u}%{+o}%{O$itemPadding}"\
"$soundIcon_siji $(Vol)%"\
"%{O$itemPadding}%{-u}%{-o}"\
"%{O$itemOffset}"\
"$(VerticalBar $mikuPink $borderWidth)"\
"%{O$itemOffset}"
	# Battery formatting
echo -en \
"%{U$mikuGreen}%{F$mikuGreen}"\
"%{+o}%{O$itemPadding}"\
"$batteryIcon_siji $(Battery)%"\
"%{O$itemPadding}"\
"$(VerticalBar $mikuGreen $borderWidth)"\
"%{-o}"\
"%{O$itemOffset}"
	# Time formatting
echo -en \
"%{U$mikuGray}%{F$mikuGray}"\
"%{+o}%{O$itemPadding}"\
"$(date +'%H:%M')"\
"%{O$itemPadding}"\
"$(VerticalBar $mikuGray $borderWidth)"\
"%{-o}%{B-}%{F-}%{U-}"

}
while true 
do
    echo "$(Print)" 
    sleep 1
done \
    | lemonbar -p \
        -u $borderWidth\
        -U $mikuGreen\
        -g x24\
        -f "$font_siji"\
        -f "$font_zevvPeep"\
        -B $mikuBlack\
        -F $mikuGreen|\
    sh 
