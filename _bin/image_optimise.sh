#!/bin/sh

# Resize everything to a max width of 2000 pixels

cd images/

mkdir for_shows_process/

cp for_shows_uncompressed/* for_shows_process/

find for_shows_process/ -name "*.png" -exec mogrify -format jpg {} \;

rm -rf for_shows_process/*.png

mogrify -resize '1500>' for_shows_process/*.jpg

# Optimise JPEGs
for i in for_shows_process/*.jpg; do jpegoptim "$i" -m90; done
