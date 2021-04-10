#!/bin/bash

# changable config variables:
IMAGE_LOCATION="./tiles"
TEMP_LOCATION="./temp"
OS_LOGO="artix.png"
#---
asdf=""
xrandr --listactivemonitors | grep -oE '[^ ]+$' | sed '1d' | while read -r line ; do
	RES=$(xrandr --query --verbose | grep $line | cut -d ' ' -f 3)
	if [ $RES == "primary" ]; then
		RES=$(xrandr --query --verbose | grep $line | cut -d ' ' -f 4 | cut -d '+' -f 1)
		echo $RES
	else
		RES=$(cut -d '+' -f 1 <<<$RES)
		echo $RES
	fi
	PIC=`ls -rt -d -1 $IMAGE_LOCATION/* | shuf -n 1`
	PICNAME=$(basename -- "$PIC")
	convert -size $RES tile:$PIC -gravity SouthEast -draw "image over 25,25 0,0 $OS_LOGO" $TEMP_LOCATION/temp$RES$PICNAME
	asdf="$asdf --output $line --center $TEMP_LOCATION/temp$RES$PICNAME"
	xwallpaper $asdf # this is done each loop, because the asdf var is lost upon exiting the loop
			 # the workarounds are kinda stinky and I dont want to do them
			 # http://mywiki.wooledge.org/BashFAQ/024
	echo "xwallpaper $asdf"
done
rm $TEMP_LOCATION/*


