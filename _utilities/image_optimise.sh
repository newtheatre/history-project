#!/bin/sh

optipng images/for_shows/*.png

for i in images/for_shows/*.jpg; do jpegoptim "$i"; done
