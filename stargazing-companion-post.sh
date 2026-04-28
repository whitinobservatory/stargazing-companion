#!/usr/bin/env bash

# Stargazing Companion, https://github.com/whitinobservatory/stargazing-companion/
# with gratitude to Steve Berardi and Starplot, https://github.com/steveberardi/starplot/blob/main/CITATION.cff
# 2025 Dec 1 - Jonathan Kemp, initial version, Whitin Observatory
# 2026 Apr 16 - Jonathan Kemp, release version, Whitin Observatory

# stargazing companion
# post processing bash script
# modifies dark background graphic, light background graphic, sensible printable graphic
# bash required environment
# tested with bash version 5.2.21
# imagemagick required dependency, https://imagemagick.org/download/
# tested with imagemagick version 6.9.12
# uses imagemagick's convert, mogrify, composite functionality
# wget or curl optional dependency, in lieu of manual download logo graphic
# tested with wget 1.21.4 and curl 8.5.0

# user general settings
# set observer geographic coordinates
coordinates="42° 18' N · 71° 18' W" # <- USER EDIT
# set observer municipality
municipality="Wellesley, MA" # <- USER EDIT
# set observer time
# note: consider middle date 14th for Feb, 15th for Apr/Jun/Sep/Nov, 16th for Jan/Mar/May/Jul/Aug/Oct/Dec
# note: Feb has 28/29 d, Apr/Jun/Sep/Nov have 30 d, Jan/Mar/May/Jul/Aug/Oct/Dec have 31 d
# note: consider date2 21:00 for Feb/Mar/Apr, 22:00 for May/Jun/Jul, 21:00 for Aug/Sept/Oct, 20:00 Nov/Dec/Jan, for mid-northern temperate latitudes
date1="2026 Apr 1 · 10 PM" # <- USER EDIT
date2="2026 Apr 15 · 9 PM" # <- USER EDIT
date3="2026 Apr 30 · 8 PM" # <- USER EDIT
# specify software web site
website1="starplot.dev" # <- USER EDIT
# specify observer web site
website2="starplotting.com" # <- USER EDIT
# specify paper size, choose one of two supported options
papersize="letter" # <- USER EDIT
# papersize="a4" # <- USER EDIT
# specify download agent, choose one of two supported options
agent="wget" # <- USER EDIT
# agent="curl" # <- USER EDIT

# user logo settings
# specify use of visual identity logo
logouse=1 # <- USER EDIT
# specify visual identity logo
# wget or curl nominally used as download agent
# alternatively manually download logo graphics and name them as logo-light-raw.png logo-dark-raw.png logo-print-raw.png
# dark logo is for dark background graphic and is typically white or light graphic on transparent background
# fallback is generic placeholder logo space
# confirm licenses, rights, and permissions for usage
logodark="https://github.com/steveberardi/starplot/raw/refs/heads/main/docs/images/mono.png" # <- USER EDIT
# light logo is for light background graphic and is typically white or light graphic on transparent background
logolight="https://github.com/steveberardi/starplot/raw/refs/heads/main/docs/images/mono.png" # <- USER EDIT
# print logo is for sensinble printable graphic and is typically black or dark graphic on transparent background
logoprint="https://github.com/steveberardi/starplot/raw/refs/heads/main/docs/images/logo500.png" # <- USER EDIT

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
darkbackground="#0e141a"
lightbackground="#59789b"
printbackground="#ffffff"
darklogo="dark"
lightlogo="dark"
printlogo="light"
darkbrightness="-18.5x0"
lightbrightness="-11x0"
printbrightness="0x0"
darktext="darkgray"
lighttext="lightgray"
printtext="black"
letterdimensions="4896x6336!"
letterborder="288"
lettersize="letter"
a4dimensions="4764x6733!"
a4border="282"
a4size="a4"

# required dependencies check
if [ ! -x "$(command -v convert)" ] || [ ! -x "$(command -v mogrify)" ] || [ ! -x "$(command -v composite)" ] ; then
	echo "imagemagick including convert, mogrify, composite functionality is not installed, error, exiting"
	exit
fi

# optional dependencies check
if [ ! -x "$(command -v wget)" ] && [ ! -x "$(command -v curl)" ] ; then
	echo "wget or curl is not installed, warning, continuing"
fi

for plot in dark light print
do

	# trim raw graphic
	convert -quality 100% -trim +repage stargazing-companion-$plot-raw.png stargazing-companion-$plot-proc.png

	# border raw graphic
	if [ $plot == "dark" ] ; then
		background=$darkbackground
	elif [ $plot == "light" ] ; then
		background=$lightbackground
	elif [ $plot == "print" ] ; then
		background=$printbackground
	fi
	mogrify -quality 100% -border 16x16 -bordercolor $background +repage stargazing-companion-$plot-proc.png

	# resize raw graphic
	mogrify -quality 100% -resize 4320x4320! +repage stargazing-companion-$plot-proc.png

	# acquire logo graphic
	if [ $plot == "dark" ] ; then
		url=$logodark
	elif [ $plot == "light" ] ; then
		url=$logodark
	elif [ $plot == "print" ] ; then
		url=$logoprint
	fi
	if [ -s logo-$plot-raw.png ] && [ $logouse == 1 ] ; then
		echo $plot "visual identity logo available"
	else
		if [ $agent == "wget" ] && [ $logouse == 1 ] ; then
			wget -q -O logo-$plot-raw.png $url
			if [ -s logo-$plot-raw.png ] ; then
				echo $plot" visual identity logo unavailable, downloaded with "$agent
			else
				convert -quality 100% -size 644x644 xc:none PNG32:logo-$plot-raw.png
				echo $plot" visual identity logo unavailable, created generic placeholder logo space"
			fi
		elif [ $agent == "curl" ] && [ $logouse == 1 ] ; then
			curl -s -L -o logo-$plot-raw.png $url
			if [ -s logo-$plot-raw.png ] ; then
				echo $plot" visual identity logo unavailable, downloaded with "$agent
			else
				convert -quality 100% -size 644x644 xc:white PNG32:logo-$plot-raw.png
				echo $plot" visual identity logo unavailable, created generic placeholder logo space"
			fi
		elif [ $logouse == 0 ] ; then
			convert -quality 100% -size 644x644 xc:white PNG32:logo-$plot-raw.png
			echo $plot" visual identity logo unavailable, created generic placeholder logo space"
		else
			echo $plot" visual identity logo unavailable"
			echo "no download agent specified, options are wget and curl, or alternative manual download"
			convert -quality 100% -size 644x644 xc:white PNG32:logo-$plot-raw.png
			echo $plot" visual identity logo unavailable, created generic placeholder logo space"
		fi
	fi

	# prepare logo graphic
	convert -quality 100% -trim +repage logo-$plot-raw.png PNG32:logo-$plot-proc.png
	mogrify -quality 100% -resize 644x644 PNG32:logo-$plot-proc.png

	# modify logo graphic
	if [ $plot == "dark" ] ; then
		brightness=$darkbrightness
	elif [ $plot == "light" ] ; then
		brightness=$lightbrightness
	elif [ $plot == "print" ] ; then
		brightness=$printbrightness
	fi
	mogrify -quality 100% -brightness-contrast $brightness PNG32:logo-$plot-proc.png

	# overlay logo graphic
	composite -quality 100% -gravity northwest -geometry +16+16 logo-$plot-proc.png stargazing-companion-$plot-proc.png stargazing-companion-$plot-temp.png
	mv -f stargazing-companion-$plot-temp.png stargazing-companion-$plot-proc.png

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
	if [ $plot == "dark" ] ; then
		text=$darktext
	elif [ $plot == "light" ] ; then
		text=$lighttext
	elif [ $plot == "print" ] ; then
		text=$printtext
	fi
	if [ $fontuse == 1 ] ; then
		mogrify -font font.ttf \
		-fill $text -pointsize 80 -gravity northeast -annotate +16+0 "$coordinates\n$municipality\n$date1\n$date2\n$date3" \
		-fill $text -pointsize 40 -gravity south -annotate -616+8 $website1 \
		-fill $text -pointsize 40 -gravity south -annotate +756+8 $website2 \
		stargazing-companion-$plot-proc.png
	else
		mogrify \
		-fill $text -pointsize 80 -gravity northeast -annotate +16+0 "$coordinates\n$municipality\n$date1\n$date2\n$date3" \
		-fill $text -pointsize 40 -gravity south -annotate -616+8 $website1 \
		-fill $text -pointsize 40 -gravity south -annotate +756+8 $website2 \
		stargazing-companion-$plot-proc.png
	fi

	# create pdf graphic
	if [ $plot == "print" ] ; then
		if [ $papersize == "letter" ] ; then
			dimensions=$letterdimensions
			border=$letterborder
		elif [ $papersize == "a4" ] ; then
			dimensions=$a4dimensions
			border=$a4border
		else
			echo "no print size specified, options are letter and a4, using default letter size"
			size="letter"
		fi
		convert -quality 100% -size $dimensions xc:white PNG32:stargazing-companion-$plot-temp1.png
		convert -quality 100% -border $border -bordercolor "#ffffff" +repage stargazing-companion-$plot-proc.png PNG32:stargazing-companion-$plot-temp2.png
		composite -quality 100% -gravity north PNG32:stargazing-companion-$plot-temp2.png PNG32:stargazing-companion-$plot-temp1.png PNG32:stargazing-companion-$plot-temp3.png
		convert -quality 100% -page $papersize PNG32:stargazing-companion-$plot-temp3.png stargazing-companion-$plot-proc.pdf
		mv -f stargazing-companion-$plot-temp3.png stargazing-companion-$plot-proc.png
		rm -f stargazing-companion-$plot-temp1.png stargazing-companion-$plot-temp2.png
	fi

	# resize png graphic
	if [ $plot == "dark" ] || [ $plot == "light" ] ; then
		mogrify -quality 100% -resize 1080x1080! stargazing-companion-$plot-proc.png
	fi

	# print png graphic
	if [ -s stargazing-companion-$plot-proc.png ] ; then
		echo $plot" processed graphic png version created"
	else
		echo $plot" processed graphic png version not created"
	fi

	# print pdf graphic
	if [ $plot == "print" ] ; then
		if [ -s stargazing-companion-$plot-proc.pdf ] ; then
			echo $plot" processed graphic pdf version created"
		else
			echo $plot" processed graphic pdf version not created"
		fi
	fi

done
