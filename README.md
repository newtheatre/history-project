![Nottingham New Theatre History Project logo](https://user-images.githubusercontent.com/15388319/146941661-9c38b674-6d27-4589-9723-2d2bec93d7c8.png)

# 📚 Nottingham New Theatre History Project

[![Build Status](https://github.com/newtheatre/history-project/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/newtheatre/history-project/actions/workflows/build.yml)
[![Code Climate](https://codeclimate.com/github/newtheatre/history-project/badges/gpa.svg)](https://codeclimate.com/github/newtheatre/history-project)
[![Issue Count](https://codeclimate.com/github/newtheatre/history-project/badges/issue_count.svg)](https://codeclimate.com/github/newtheatre/history-project)

The history project collects and publishes information on past shows, committees and other goings-on at [The Nottingham New Theatre](http://newtheatre.org.uk) the only student run theatre in England.

We use a static site generator ([Jekyll](jekyllrb.com)) among other tools to turn the data and website source hosted here into the website published at [history.newtheatre.org.uk](https://history.newtheatre.org.uk).

This project is run by [a group](https://history.newtheatre.org.uk/humans.txt) from the New Theatre's Alumni Network.

---

# 📜 Working with the Repo

There are 2 common ways to use this repository:

1. [Adding content](#user-content-1--adding--editing-content) (shows, people, etc)
2. [Editing the site](#user-content-2--editing-the-site-code) (templates, plugins, etc)

## 1. 📝 Adding & Editing Content

You can do this primarily in one of two ways: using the GitHub web interface (good for very minor tweaks); or by editing the files on your computer.

The site's [Contributor's Guide](https://history.newtheatre.org.uk/docs/contributing/) has all the information you need for this.

You'll be able to see the changes you make when you open a Pull Request with our Deploy Previews. If you'd like to see your changes locally, keep scrolling.

## 2. 💻 Editing the Site Code

If you're editing templates, plugins, and so on, you likely want to be able to view your changes and test them locally before you push. 

The first thing you'll need to do is clone (download) the repo onto your computer. You can do this a variety of ways, the easiest are either [downloading the zip](https://github.com/newtheatre/history-project/archive/refs/heads/master.zip) or using the following command, providing you have Git installed:

```bash
git clone https://github.com/newtheatre/history-project.git
```

You can then either use [Docker](#user-content--using-docker), or [build the site yourself](#user-content--building-the-site-without-docker) to see your changes.  

To save your changes back to GitHub, you will need to use a Git client, which you can do from the command line, or download and use a graphical one. We recommend [GitHub Desktop](https://desktop.github.com/) or [GitKraken](https://gitkraken.com).

### 🐳 Using Docker

[Docker](https://www.docker.com) is a cross platform software container platform. Following these instructions will allow you to build and view the site on your local machine in an environment as close to the production system as possible.

<details>
<summary><strong>ℹ️ Extra steps for Windows users</strong></summary> You will need to install WSL first, by doing the following:

- Open a Command Prompt
- run `wsl --install ubuntu`
- run `wsl --set-version ubuntu 2`
- run `wsl --set-default-version 2`
- run `wsl --set-default ubuntu`

You may then need to reboot.
</details>

#### Setting up Docker

- [Install Docker](https://www.docker.com/products/docker-desktop)
- Open a console of your choice (typically Terminal on Mac/Linux; Command Prompt on Windows).
- `cd history-project` to change into the project directory.
- Type `./run_dev.sh` (Windows users: `wsl run_dev.sh`)

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

### 🛠 Building the site (without Docker)

To get the site running locally you will need:
* A working Ruby environment (preferably version 2.7, for which you may need rvm)
* Bundler installed
* Node.js 8.x (and no higher, for which you may need nvm)
* Gulp, CoffeeScript, and Bower. 

We'll get that sorted, then install the project.

We don't recommend doing it this way on vanilla Windows, though if you use the WSL you can follow the Ubuntu instructions.

#### 1. Setting up your system

<details>
  <summary>Ubuntu</summary>

- `curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -` to setup and add a PPA for Node JS 8.x rather than a newer version.
- `sudo apt install ruby-dev rubygems nodejs libffi-dev` for an up to date Ruby with development bits and the Gem package manager, Node.js and its package manager npm.
- `sudo gem install bundler` for the Ruby depenancy manager.
- `sudo ln -s /usr/bin/nodejs /usr/bin/node` because some Node packages put it in the wrong place.
- `sudo npm install -g gulp coffeescript bower` for Gulp, CoffeeScript, and Bower.

</details>

<details>
  <summary>macOS</summary>
For ease, we recommend installing Homebrew.

- `brew install rvm nvm` for the Ruby and Node version managers 
- `rvm use 2.4` to use Ruby 2.4
- `nvm install 8 && nvm use 8` to install and use Node 8
- `gem install bundler` for the Ruby dependency manager.
- `npm install -g gulp coffeescript bower` for Gulp, CoffeeScript, and Bower.
</details>

#### 2. Project Install

- [Optional:] `bundle config --local path vendor/bundle` to install the Ruby packages to within the repository folder. Helpful if you are working on multiple different projects.
- `bundle install` to install all the Ruby dependencies the project needs to build.
- `npm install` to install all the Node dependencies the project needs to build.
  - You may also need to run `npm link gulp-v3` to get our version of gulp to behave.
- `bower install` to install all the frontend dependencies the project needs to build.

#### 3. Run

- `gulp build` to build the site to _site.
- OR `gulp debug` does the same but skips minification and enables Jekyll's incremental builds.
- `gulp server` to serve the site using the built in webserver. Changes to Sass & Coffee files will trigger an automatic frontend rebuild and reload. Content (Jekyll) changes will not, this is because Jekyll takes a considerable time to run.

> ℹ️ If `gulp` commands don't work, try using `node_modules/.bin/gulp` (eg `node_modules/.bin/gulp build`) instead.

To get more verbose output from Jekyll, run `export JEKYLL_LOG_LEVEL=debug` before building.

---

## 🧪 Testing

After building the site you can run the test suite with `gulp test`. Currently we test for bad links, valid image tags, script references and the validity of site JSON feeds.

Bear in mind you may want to disable htmltest's external link checking as this may take some time on a consumer internet connection.

You may also test the syntax of YAML front-matter via `gulp yamllint`.

Branches pushed to the GitHub repo are have preview builds deployed on Netlify, you can find links to the most recent ones here: <https://app.netlify.com/sites/history-project-dev/deploys>.

---

## 📷 Asset Storage

All photographs, image assets, and videos under 20 minutes in length are stored using the [theatre's SmugMug](https://photos.newtheatre.org.uk/).

Other binary assets are stored under `assets/` using [Git LFS](https://git-lfs.github.com/). This separates these large files from the main repository. If you do not have LFS set up on your machine please do not attempt to commit assets as this would bloat the repository.

---

## 💌 Special Thanks

- Browser testing tools generously provided by [BrowserStack](https://www.browserstack.com/).

--- 

## 📋 Licence

This project as a whole isn't particularly helpful for other organizations, what we're doing here can be described as [*coding in the open*](https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/), rather than building an open source project. That said parts of the project may be of interest or use to others. This repository is a mix of source and content, as such there are two licences that apply.

- All source files (HTML templates, Sass, CoffeeScript, Ruby, shell scripts) are released under the [MIT licence](https://github.com/newtheatre/history-project/blob/master/LICENCE).
- All content files (HTML files, Markdown, YAML datafiles, images, graphics) are copyright © The Nottingham New Theatre 2016.
