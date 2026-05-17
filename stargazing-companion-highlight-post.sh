#!/usr/bin/env bash

# Stargazing Companion Highlight, https://github.com/whitinobservatory/stargazing-companion/
# with gratitude to Steve Berardi and Starplot, https://github.com/steveberardi/starplot/blob/main/CITATION.cff
# 2026 Feb 26 - Jonathan Kemp, initial version, Whitin Observatory
# 2026 May 17 - Jonathan Kemp, release version, Whitin Observatory

# stargazing companion highlight
# post processing bash script
# modifies dark sky gradient background graphic
# bash required environment
# tested with bash version 5.2.21
# imagemagick required dependency, https://imagemagick.org/download/
# tested with imagemagick version 6.9.12
# uses imagemagick's convert, mogrify, composite functionality
# wget or curl optional dependency, in lieu of manual download logo graphic
# tested with wget 1.21.4 and curl 8.5.0
#
# user general settings
# set observer geographic coordinates
coordinates="42° 18' N · 71° 18' W" # <- USER EDIT
# set observer municipality
municipality="Wellesley, MA" # <- USER EDIT
# set observer time
# note: use day before to add preceding moon location
date1="2026 May 18 · 9 PM" # <- USER EDIT
# note: use main date for all objects
date2="2026 May 19 · 9 PM" # <- USER EDIT
# note: use day after to add following moon location
date3="2026 May 20 · 9 PM" # <- USER EDIT
# specify software web site
website1="starplot.dev" # <- USER EDIT
# specify observer web site
website2="starplotting.com" # <- USER EDIT
# specify download agent, choose one of two supported options
agent="wget" # <- USER EDIT
# agent="curl" # <- USER EDIT

# user logo settings
# specify use of visual identity logo
logouse=1 # <- USER EDIT
# specify visual identity logo
# wget or curl nominally used as download agent
# alternatively manually download logo graphics and name ir as logo-dark-raw.png
# dark logo is for dark background graphic and is typically white or light graphic on transparent background
# fallback is generic placeholder logo space
# confirm licenses, rights, and permissions for usage
logodark="https://github.com/steveberardi/starplot/raw/refs/heads/main/docs/images/mono.png" # <- USER EDIT

# user font settings
# specify use of font
fontuse=1 # <- USER EDIT
# specify font
# wget or curl nominally used as download agent
# alternatively manual download font and name it as font.ttf
# fallback is system default
# confirm licenses, rights, and permissions for usage
fontfile="https://github.com/rsms/inter/raw/refs/heads/master/docs/font-files/InterVariable.ttf" # <- USER EDIT

# specific graphic settings
darkbackground="#1a2229"
darklogo="dark"
darkbrightness="-18.5x0"
darktext="darkgray"

# required dependencies check
if [ ! -x "$(command -v convert)" ] || [ ! -x "$(command -v mogrify)" ] || [ ! -x "$(command -v composite)" ] ; then
	echo "imagemagick including convert, mogrify, composite functionality is not installed, error, exiting"
	exit
fi

# optional dependencies check
if [ ! -x "$(command -v wget)" ] && [ ! -x "$(command -v curl)" ] ; then
	echo "wget or curl is not installed, warning, continuing"
fi

plot="dark-sky-gradient"

# trim raw graphic
convert -quality 100% -trim +repage stargazing-companion-highlight-raw.png stargazing-companion-highlight-proc.png

# border raw graphic
background=$darkbackground
mogrify -quality 100% -border 16x16 -bordercolor $background +repage stargazing-companion-highlight-proc.png
mogrify -quality 100% -gravity south -splice x128 -background $background +repage stargazing-companion-highlight-proc.png

# resize raw graphic
mogrify -quality 100% -resize 4320x4320! +repage stargazing-companion-highlight-proc.png

# acquire logo graphic
url=$logodark
if [ -s logo-highlight-raw.png ] && [ $logouse == 1 ] ; then
	echo $plot "visual identity logo available"
else
	if [ $agent == "wget" ] && [ $logouse == 1 ] ; then
		wget -q -O logo-highlight-raw.png $url
		if [ -s logo-highlight-raw.png ] ; then
			echo $plot" visual identity logo unavailable, downloaded with "$agent
		else
			convert -quality 100% -size 480x480 xc:none PNG32:logo-highlight-raw.png
			echo $plot" visual identity logo unavailable, created generic placeholder logo space"
		fi
	elif [ $agent == "curl" ] && [ $logouse == 1 ] ; then
		curl -s -L -o logo-highlight-raw.png $url
		if [ -s logo-highlight-raw.png ] ; then
			echo $plot" visual identity logo unavailable, downloaded with "$agent
		else
			convert -quality 100% -size 480x480 xc:white PNG32:logo-highlight-raw.png
			echo $plot" visual identity logo unavailable, created generic placeholder logo space"
		fi
	elif [ $logouse == 0 ] ; then
		convert -quality 100% -size 480x480 xc:white PNG32:logo-highlight-raw.png
		echo $plot" visual identity logo unavailable, created generic placeholder logo space"
	else
		echo $plot" visual identity logo unavailable"
		echo "no download agent specified, options are wget and curl, or alternative manual download"
		convert -quality 100% -size 480x480 xc:white PNG32:logo-highlight-raw.png
		echo $plot" visual identity logo unavailable, created generic placeholder logo space"
	fi
fi

# prepare logo graphic
convert -quality 100% -trim +repage logo-highlight-raw.png PNG32:logo-highlight-proc.png
mogrify -quality 100% -resize 480x480 PNG32:logo-highlight-proc.png

# modify logo graphic
brightness=$darkbrightness
mogrify -quality 100% -brightness-contrast $brightness PNG32:logo-highlight-proc.png

# overlay logo graphic
composite -quality 100% -gravity southwest -geometry +16+16 logo-highlight-proc.png stargazing-companion-highlight-proc.png stargazing-companion-highlight-temp.png
mv -f stargazing-companion-highlight-temp.png stargazing-companion-highlight-proc.png

# overlay text information
if [ -s font.ttf ] && [ $fontuse == 1 ] ; then
	echo "font available"
else
	if [ $agent == "wget" ] && [ $fontuse == 1 ] ; then
		wget -q -O font.ttf $fontfile
		if [ -s font.ttf ] ; then
			echo "font unavailable, downloaded with "$agent
		else
			echo "font unavailable, will use font default"
			fontuse="0"
		fi
	elif [ $agent == "curl" ] && [ $fontuse == 1 ] ; then
		curl -s -L -o font.ttf $fontfile
		if [ -s font.ttf ] ; then
			echo "font unavailable, downloaded with "$agent
		else
			echo "font unavailable, will use font default"
			fontuse="0"
		fi
	elif [ $fontuse == 0 ] ; then
		echo "will use font default"
	else
		echo "font unavailable, will use font default"
		echo "no download agent specified, options are wget and curl, or alternative manual download"
	fi
fi
text=$darktext
if [ $fontuse == 1 ] ; then
	mogrify -font font.ttf \
	-fill $text -pointsize 80 -gravity southeast -annotate +16+0 "$coordinates\n$municipality\n$date1\n$date2\n$date3" \
	-fill $text -pointsize 40 -gravity south -annotate -616+8 $website1 \
	-fill $text -pointsize 40 -gravity south -annotate +756+8 $website2 \
	stargazing-companion-highlight-proc.png
else
	mogrify \
	-fill $text -pointsize 80 -gravity southeast -annotate +16+0 "$coordinates\n$municipality\n$date1\n$date2\n$date3" \
	-fill $text -pointsize 40 -gravity south -annotate -616+8 $website1 \
	-fill $text -pointsize 40 -gravity south -annotate +756+8 $website2 \
	stargazing-companion-highlight-proc.png
fi

# resize png graphic
mogrify -quality 100% -resize 1080x1080! stargazing-companion-highlight-proc.png

# print png graphic
if [ -s stargazing-companion-highlight-proc.png ] ; then
	echo $plot" processed graphic png version created"
else
	echo $plot" processed graphic png version not created"
fi
