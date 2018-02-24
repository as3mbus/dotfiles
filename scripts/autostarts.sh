#!/bin/bash

[ ! -z $(pidof compton) ] && pkill compton
[ ! -z $(pidof redshift) ] && pkill redshift
[ ! -z $(pidof workrave) ] && pkill workrave
[ ! -z $(pidof lemonbar) ] && pkill lemonbar
[ ! -z $(pidof polybar) ] && pkill polybar
[ ! -z $(pidof conky) ] && pkill conky
[ ! -z $(pidof tint2) ] && pkill tint2

#/home/as3mbus/.scripts/statusbar.sh &
#$(which polybar) miku &
$(which tint2)&
$(which workrave) &
$(which compton) -bc &
$(which redshift-gtk) &
$(which conky) &
exit 0
