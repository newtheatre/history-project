#!/bin/sh

# Resize everything to a max width of 2000 pixels

cd images/

mkdir for_shows_process/
cp for_shows_uncompressed/* for_shows_process/

# Lowercase ONLY
find for_shows_process/ -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;

# Convert PNG to JPEG and remove PNGs
find for_shows_process/ -name "*.png" -exec mogrify -format jpg {} \;
rm -rf for_shows_process/*.png

# Resize
mogrify -resize '1500>' for_shows_process/*.jpg

# Optimise JPEGs
for i in for_shows_process/*.jpg; do jpegoptim "$i" -m90; done

# Remove EXIF
for i in for_shows_process/*.jpg; do echo "Processing $i"; exiftool -all= "$i"; done
rm -f for_shows_process/*.jpg_original
