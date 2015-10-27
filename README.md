# Nottingham New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project)
[![Dependency Status](https://gemnasium.com/newtheatre/history-project.svg)](https://gemnasium.com/newtheatre/history-project)
[![Code Climate](https://codeclimate.com/github/newtheatre/history-project/badges/gpa.svg)](https://codeclimate.com/github/newtheatre/history-project)

The history project aims to collect information on past shows, committees and other goings-on at The Nottingham New Theatre.

## System

To get the site running locally you will need a working Ruby environment, the bundler gem installed, ImageMagick, Node.js, Coffeescript, and Bower. The following instructions work on Ubuntu.

- `sudo apt-get install ruby-dev rubygems nodejs npm imagemagick` for an up to date Ruby with development bits and the Gem package manager, Node.js and its package manager npm, and finally Imagemagick for image manipulation.
- `sudo gem install bundler` for the Ruby depenancy manager
- `sudo ln -s /usr/bin/nodejs /usr/bin/node` because some Node packages put it in the wrong place
- `sudo npm install -g coffee-script bower` for Coffeescript and Bower

## Project Install

- `git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.
- `cd history-project` to change into the directory.
- `bundle install` to install all the Ruby dependencies the project needs to build.
- `npm install` to install all the Node dependencies the project needs to build.
- `bower install` to install all the frontend dependencies the project needs to build.

## Run

- `_bin/build.sh` to build the site to _site.
- `cd _site && python -m SimpleHTTPServer` to serve the site using the Python HTTP server (should be on all *nix machines)

## Editing

See the [site documentation](http://history.newtheatre.org.uk/docs/)

## Useful Stuff

### HTML Proofing

`bundle exec htmlproof _site` will check the site for mistakes in the generated output (broken links, missing alt attributes on images etc).


## Repo Mirror

This repo is mirrored here: http://git.fullaf.com/will/history-project. It's kept up to date by Will's pushes so may be a little behind.
