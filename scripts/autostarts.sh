#!/bin/bash

[ ! -z $(pidof compton) ] && pkill compton
[ ! -z $(pidof redshift) ] && pkill redshift
[ ! -z $(pidof workrave) ] && pkill workrave
[ ! -z $(pidof lemonbar) ] && pkill lemonbar
[ ! -z $(pidof polybar) ] && pkill polybar

/home/as3mbus/.scripts/statusbar.sh &
$(which workrave) &
$(which compton) -bc &
$(which polybar) miku &
$(which redshift-gtk) &
