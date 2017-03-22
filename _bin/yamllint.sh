#!/bin/bash

TESTDIR=tmp/yamllint

# Clear last run
rm -rf $TESTDIR

# Test datafiles
yamllint _data/

# Remove all markdown content, anything after the second ---
for fn in $(find . -name '*.md' -or -name '*.html' | egrep "^(./_committees|./_content|./_people|./_shows|./_venues)"); do
    # https://askubuntu.com/questions/642153/how-do-i-delete-everything-after-second-occurrence-of-quotes-using-the-command-l
    # sed -i -r 'H;1h;$!d;x; s/(([^---]*"){2}).*/\1/' $fn
    mkdir -p `dirname $TESTDIR/$fn`
    awk -v RS='---' -v ORS='---' 'NR==1{print} NR==2{print; printf"\n";exit}' $fn > $TESTDIR/$fn
done

# Loop over directories containing *.md files, this reduces the number of times
# we need to start up yamllint.
for dir in $(find $TESTDIR -type d)
do
    # Only run if $dir contains *.md files
    mdfiles=(`find $dir -maxdepth 1 -name "*.md"`)
    if [ ${#mdfiles[@]} -gt 0  ]; then
        yamllint $dir/*.md
    fi
    # Only run if $dir contains *.html files
    htmltest=(`find $dir -maxdepth 1 -name "*.html"`)
    if [ ${#htmltest[@]} -gt 0  ]; then
        yamllint $dir/*.html
    fi
done
