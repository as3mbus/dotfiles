#!/bin/sh
basedir=$(dirname $0)
source $basedir/config.sh
source $basedir/resource.sh


# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'
# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'
# format output for i3bar
echo -en '
[{ "full_text" : "'$userIcon_awesome $(whoami)'" ,
    "color" : "'$mikuPink'",
    "align" : "left",
    "separator_block_width" : 20
  },
  { "full_text" : "' $circleIcon_awesome $(hostname -s) '" ,
    "color" : "'$mikuGray'",
    "align" : "left",
    "separator_block_width" : 20,
    "separator" : false
  },
  { "full_text" : "' $monitorIcon_awesome $(uname -r) $(uname) '" ,
    "color" : "'$mikuBlack'",
    "background" : "'$mikuGreen'",
    "align" : "left",
    "separator_block_width" : 20,
    "separator" : false
  },
  { "full_text" : " '$brushIcon_awesome' Hatsune Miku I3 Theme ", 
    "color" : "'$mikuGreen'"
  }],
'
while true
do
    :
done
