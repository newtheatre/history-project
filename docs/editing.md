---
layout: docs
group: docs
title: Editing
sort: 10
---

To edit the site you have several options, firstly though you must be added to the [repository](http://github.com/newtheatre/history-project) by an [owner](https://github.com/orgs/newtheatre/people).

## Editing Online

You can then either use the GitHub website directly or Prose (probably the better option). Ensure you have a verified email address with GitHub otherwise your changes will not trigger a build.

To use [Prose](http://prose.io), visit the site and authorise with GitHub. Find the history-project repo to load up the file list. Navigate to the file you're interested in and click 'Edit'.

Meta data can be edited on Prose by using one of the buttons on the far right.

## Editing Locally

<div class="box-info"><i class="fa fa-info-circle"></i>This method requires a certain amount of technical knowledge.</div>

This is the more complicated option, the benefits are you can use a desktop text editor and run the entire site on your machine to preview changes before they go live. You should have knowledge of Git and the command line to do this.

The only dependences of this site are Jekyll and `jekyll-sitemap`. You can find instructions for [installing Jekyll on their website](http://jekyllrb.com/docs/installation/).

If you have bundler on your system you can just do `bundle install` to install all the dependencies.

To get jekyll up and running do `jekyll serve --watch`, the site will then be available on <http://localhost:4000>.
