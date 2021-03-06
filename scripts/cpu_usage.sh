#!/bin/bash

# yanked from :  https://github.com/addy-dclxvi/almighty-dotfiles executor/usecpu

# Source: http://askubuntu.com/a/450136
# I only slightly modify this script to add an option to show icon, useful for my tint2 executor
# Also useful for polybar custom script, dzen2 feeder, conkybar, lemonbar feeder, dunst notify, etc.
# 'usedcpu -i' = with icon, 'usedcpu' = text only
# Cheers!
# Addy

# additional editting to make things work by removing unset and setting index to reflect upon right value
CPU()
{
PREV_TOTAL=0
PREV_IDLE=0

cpuFile="/tmp/.cpu"

if [[ -f "${cpuFile}" ]]; then
  fileCont=$(cat "${cpuFile}")
  PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
  PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
fi

CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
IDLE=${CPU[4]}                        # Get the idle CPU time.

# Calculate the total CPU time.
TOTAL=0

for VALUE in "${CPU[@]:1:4}"; do
  let "TOTAL=$TOTAL+$VALUE"
done

if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
  if  [[ $1 = "-i" ]]; then
    text=$(printf '　%3d %%' $DIFF_USAGE)
  else
    text=$(printf '%3d　%%' $DIFF_USAGE)
  fi
else
  if  [[ $1 = "-i" ]]; then
    text="　?"
  else
    text="?"
  fi
fi
echo "$text"

# Remember the total and idle CPU times for the next check.
echo "${TOTAL}" > "${cpuFile}"
echo "${IDLE}" >> "${cpuFile}"
}
CPU $1
