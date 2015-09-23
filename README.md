# Nottingham New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project)
[![Dependency Status](https://gemnasium.com/newtheatre/history-project.svg)](https://gemnasium.com/newtheatre/history-project)
[![Code Climate](https://codeclimate.com/github/newtheatre/history-project/badges/gpa.svg)](https://codeclimate.com/github/newtheatre/history-project)

The history project aims to collect information on past shows, committees and other goings-on at The Nottingham New Theatre.


## Install

To get the site running locally you will need a working Ruby environment, the bundler gem installed (`sudo gem install bundler`) and ImageMagick (usually `sudo apt-get install imagemagick`). Then do the following:

`git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.

`cd history-project` to change into the directory.

`bundle install` to install all the Ruby dependencies the project needs to build.

`npm install` to install all the Node dependencies the project needs to build.

`bundle exec jekyll serve --watch` to build the site and serve it on http://localhost:4000 when done. File changes will trigger a rebuild.


## Editing

See the [site documentation](http://history.newtheatre.org.uk/docs/)


## Useful Stuff

### Renaming txt files

Rename all .txt files to .md in a directory:

```
for file in *.txt
do
mv $file `echo $file | sed 's/\(.*\.\)txt/\1md/'`
done
```

### HTML Proofing

`bundle exec htmlproof _site` will check the site for mistakes in the generated output (broken links, missing alt attributes on images etc).


## Repo Mirror

This repo is mirrored here: http://git.fullaf.com/will/history-project. It's kept up to date by Will's pushes so may be a little behind.
