# Nottingham New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project)
[![Dependency Status](https://gemnasium.com/newtheatre/history-project.svg)](https://gemnasium.com/newtheatre/history-project)
[![Code Climate](https://codeclimate.com/github/newtheatre/history-project/badges/gpa.svg)](https://codeclimate.com/github/newtheatre/history-project)
[![Issue Count](https://codeclimate.com/github/newtheatre/history-project/badges/issue_count.svg)](https://codeclimate.com/github/newtheatre/history-project)

The history project collects and publishes information on past shows, committees and other goings-on at [The Nottingham New Theatre](http://newtheatre.org.uk) the only student run theatre in England.

We use a static site generator ([Jekyll](jekyllrb.com)) among other tools to turn the data and website source hosted here into the website published at [history.newtheatre.org.uk](https://history.newtheatre.org.uk).

This project is run by [a group](https://history.newtheatre.org.uk/humans.txt) from the New Theatre's Alumni Network.

## Running Locally

### System

To get the site running locally you will need a working Ruby environment, the bundler gem installed, Node.js, Gulp, CoffeeScript, and Bower. The following instructions work on Ubuntu.

- `sudo apt-get install ruby-dev rubygems nodejs npm` for an up to date Ruby with development bits and the Gem package manager, Node.js and its package manager npm.
- `sudo gem install bundler` for the Ruby depenancy manager.
- `sudo ln -s /usr/bin/nodejs /usr/bin/node` because some Node packages put it in the wrong place.
- `sudo npm install -g gulp coffee-script bower` for Gulp, CoffeeScript and Bower.

### Project Install

- `git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.
- `cd history-project` to change into the directory.
- `bundle install` to install all the Ruby dependencies the project needs to build.
- `npm install` to install all the Node dependencies the project needs to build.
- `bower install` to install all the frontend dependencies the project needs to build.

### Run

- `gulp build` to build the site to _site.
- OR `gulp debug` does the same but skips minification and enables Jekyll's incremental builds.
- `gulp server` to serve the site using the built in webserver. Changes to Sass & Coffee files will trigger an automatic frontend rebuild and reload. Content (Jekyll) changes will not, this is because Jekyll takes a considerable time to run.

### Test

- `gulp test` to run test suite locally. Currently we test for bad links, valid image tags, script references and the validity of site JSON feeds.

## Vagrant

Vagrant is a cross platform virtual machine manager. It will allow you to build the site on your local machine in an environment as close as possible to the Travis script that is actually used. It is strongly recommended that you follow the [Vagrant getting started guide](https://docs.vagrantup.com/v2/getting-started/index.html).

To get started, you will need:

- [Oracle Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

Once you have download the requirements and installed them successfully you simply need to bring the box up, and connect to it:

- `vagrant up`
- `vagrant ssh`
- `cd /vagrant`

The vagrant box has port 8000 mapped to 8000 on your local machine, so `http://127.0.0.1:8000` should still work.

## Editing

See the [site documentation](https://history.newtheatre.org.uk/docs/).

## Asset Storage

All photographs and image assets are stored using the [theatre's SmugMug](https://photos.newtheatre.org.uk/).

Other binary assets are stored under `assets/` using [Git LFS](https://git-lfs.github.com/). This separates these large files from the main repository. If you do not have LFS set up on your machine please do not attempt to commit assets as this would bloat the repository.

## Special Thanks

- Browser testing tools generously provided by [BrowserStack](https://www.browserstack.com/).

## Licence

This project as a whole isn't particularly helpful for other organizations, what we're doing here can be described as [*coding in the open*](https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/), rather than building an open source project. That said parts of the project may be of interest or use to others. This repository is a mix of source and content, as such there are two licences that apply.

- All source files (HTML templates, Sass, CoffeeScript, Ruby, shell scripts) are released under the [MIT licence](https://github.com/newtheatre/history-project/blob/master/LICENCE).
- All content files (HTML files, Markdown, YAML datafiles, images, graphics) are copyright © The Nottingham New Theatre 2016.

