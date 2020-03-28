# Nottingham New Theatre History Project

[![Build Status](https://travis-ci.org/newtheatre/history-project.svg?branch=master)](https://travis-ci.org/newtheatre/history-project)
[![Code Climate](https://codeclimate.com/github/newtheatre/history-project/badges/gpa.svg)](https://codeclimate.com/github/newtheatre/history-project)
[![Issue Count](https://codeclimate.com/github/newtheatre/history-project/badges/issue_count.svg)](https://codeclimate.com/github/newtheatre/history-project)

The history project collects and publishes information on past shows, committees and other goings-on at [The Nottingham New Theatre](http://newtheatre.org.uk) the only student run theatre in England.

We use a static site generator ([Jekyll](jekyllrb.com)) among other tools to turn the data and website source hosted here into the website published at [history.newtheatre.org.uk](https://history.newtheatre.org.uk).

This project is run by [a group](https://history.newtheatre.org.uk/humans.txt) from the New Theatre's Alumni Network.

## Running Locally

### System

To get the site running locally you will need a working Ruby environment, the bundler gem installed, Node.js, Gulp, CoffeeScript, and Bower. The following instructions work on Ubuntu.

- `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -` to setup and add a PPA for Node JS 6.x rather than the older 4.x versions.
- `sudo apt install ruby-dev rubygems nodejs libffi-dev` for an up to date Ruby with development bits and the Gem package manager, Node.js and its package manager npm.
- `sudo gem install bundler` for the Ruby depenancy manager.
- `sudo ln -s /usr/bin/nodejs /usr/bin/node` because some Node packages put it in the wrong place.
- `sudo npm install -g gulp coffee-script bower` for Gulp, CoffeeScript and Bower.

### Project Install

- `git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.
- `cd history-project` to change into the directory.
- `bundle install` to install all the Ruby dependencies the project needs to build.
- `npm install` to install all the Node dependencies the project needs to build.
  - You may also need to run `npm link gulp-v3` to get our version of gulp to behave.
- `bower install` to install all the frontend dependencies the project needs to build.

### Run

- `gulp build` to build the site to _site.
- OR `gulp debug` does the same but skips minification and enables Jekyll's incremental builds.
- `gulp server` to serve the site using the built in webserver. Changes to Sass & Coffee files will trigger an automatic frontend rebuild and reload. Content (Jekyll) changes will not, this is because Jekyll takes a considerable time to run.

To get more verbose output from Jekyll, run `export JEKYLL_LOG_LEVEL=debug` before building.

### Test

`gulp test` to run test suite locally. Currently we test for bad links, valid image tags, script references and the validity of site JSON feeds.

Branches pushed to the GitHub repo are have preview builds deployed on Netlify, you can find links to the most recent ones here: <https://app.netlify.com/sites/history-project-dev/deploys>.

## Docker

[Docker](https://www.docker.com) is a cross platform software container platform. Following these instructions will allow you to build
and view the site on your local machine in an environment as close to the production system as possible.

- [Install Docker](https://www.docker.com/community-edition) (on windows, you probably want [Docker Toolbox](https://www.docker.com/products/docker-toolbox))
- On windows, open the 'Docker Quickstart Terminal'. On Mac/Linux use a console of your choice.
- `git clone https://github.com/newtheatre/history-project.git` to clone the repo to your computer.
- `cd history-project` to change into the directory.
- Type `./run_dev.sh`

Once everything has finished running, you should see the site at `http://localhost:8000`. Hit
<kbd>ctrl</kbd>+<kbd>c</kbd> to stop the server. If using 'Docker Toolbox' and `localhost` doesn't work, you can find the IP address of the virtual machine by running `echo " $(docker-machine ip default)"`

By default `./run_dev.sh` uses the parameters `start` `install` `build` `test` `serve` in that order.

- `start` builds the docker container, and starts it running in the background
- `install` installs all necessary dependencies for the site
- `build` builds the jekyll site
- `test` runs the test suite
- `serve` runs a server so you can view the site locally
- `stop` halts and destroys the docker container. You will need to run `start` and `install` again after running this

You can add/remove steps to `./run_dev` as needed. For example, there is no need to run `start` or `install`
every time you want to build the site.

Environment variables (such as the Smugmug API key) can be changed by modifying the `ENV` lines in the Dockerfile (and then running `start` again).

## Editing

See the [site documentation](https://history.newtheatre.org.uk/docs/).

## Testing

After building the site you can run the test suite with `gulp test`. Bear in mind you may want to disable htmltest's external link checking as this may take some time on a consumer internet connection.

You may also test the syntax of YAML front-matter via `gulp yamllint`.

## Asset Storage

All photographs and image assets are stored using the [theatre's SmugMug](https://photos.newtheatre.org.uk/).

Other binary assets are stored under `assets/` using [Git LFS](https://git-lfs.github.com/). This separates these large files from the main repository. If you do not have LFS set up on your machine please do not attempt to commit assets as this would bloat the repository.

## Special Thanks

- Browser testing tools generously provided by [BrowserStack](https://www.browserstack.com/).

## Licence

This project as a whole isn't particularly helpful for other organizations, what we're doing here can be described as [*coding in the open*](https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/), rather than building an open source project. That said parts of the project may be of interest or use to others. This repository is a mix of source and content, as such there are two licences that apply.

- All source files (HTML templates, Sass, CoffeeScript, Ruby, shell scripts) are released under the [MIT licence](https://github.com/newtheatre/history-project/blob/master/LICENCE).
- All content files (HTML files, Markdown, YAML datafiles, images, graphics) are copyright © The Nottingham New Theatre 2016.

