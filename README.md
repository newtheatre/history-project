# New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project) [![Dependency Status](https://gemnasium.com/newtheatre/history-project.svg)](https://gemnasium.com/newtheatre/history-project)

The history project aims to collect information on past shows, committees and other goings-on at The New Theatre.

## Editing

See the [site documentation](http://history.newtheatre.org.uk/docs/)

## Useful Stuff

Rename all .txt files to .md in a directory:

```
for file in *.txt
do
mv $file `echo $file | sed 's/\(.*\.\)txt/\1md/'`
done
```