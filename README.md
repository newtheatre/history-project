# Nottingham New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project)
[![Dependency Status](https://gemnasium.com/newtheatre/history-project.svg)](https://gemnasium.com/newtheatre/history-project)

The history project aims to collect information on past shows, committees and other goings-on at The Nottingham New Theatre.

## Running Locally

### System

To get the site running locally you will need a working Ruby environment, the bundler gem installed, ImageMagick, Node.js, Coffeescript, and Bower. The following instructions work on Ubuntu.

- `sudo apt-get install ruby-dev rubygems nodejs npm imagemagick` for an up to date Ruby with development bits and the Gem package manager, Node.js and its package manager npm, and finally Imagemagick for image manipulation.
- `sudo gem install bundler` for the Ruby depenancy manager
- `sudo ln -s /usr/bin/nodejs /usr/bin/node` because some Node packages put it in the wrong place
- `sudo npm install -g coffee-script bower` for Coffeescript and Bower

### Project Install

- `git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.
- `cd history-project` to change into the directory.
- `bundle install` to install all the Ruby dependencies the project needs to build.
- `npm install` to install all the Node dependencies the project needs to build.
- `bower install` to install all the frontend dependencies the project needs to build.

### Run

- `bundle exec rake build` to build the site to _site.
- `cd _site && python -m SimpleHTTPServer` to serve the site using the Python HTTP server (should be on all *nix machines)

### Test

- `bundle exec rake test` to run test suite locally.

## Vagrant

Vagrant is a cross platform virtual machine manager. It will allow you to build the site on your local machine in an environment as close as possible to the travis script that is actually used. It is strognly recomended that you follow the [Vagrant getting started guide](https://docs.vagrantup.com/v2/getting-started/index.html).
To get started, you will need:

- [Oracle Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

Once you have download the requirements and installed them successfully you simply need to bring the box up, and connect to it:

- `vagrant up`
- `vagrant ssh`
- `cd /vagrant`

The vagrant box has port 8000 mapped to 8000 on your local machine, so `http://127.0.0.1:8000` should still work.

## Editing

See the [site documentation](https://history.newtheatre.org.uk/docs/)

## Repo Mirror

This repo is mirrored here: http://git.fullaf.com/will/history-project. It's kept up to date by Will's pushes so may be a little behind.
