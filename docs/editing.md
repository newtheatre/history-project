---
layout: docs
group: docs
title: Editing
sort: 10
---

To edit the site you have several options, firstly though you must be added to the [repository](http://github.com/newtheatre/history-project) by an [owner](https://github.com/orgs/newtheatre/people).

## Editing Online

You can then either use the GitHub website directly or Prose. Ensure you have a verified email address with GitHub otherwise your changes will not trigger a build.

To use the GitHub website use the <strong><i class="octicon octicon octicon-pencil"></i> Edit This Page</strong> button to launch the editor. If you don't have write access to the repo you will be prompted to create a fork and will be led through the process of creating a pull request.

To use [Prose](http://prose.io), visit the site and authorise with GitHub. Find the history-project repo to load up the file list. Navigate to the file you're interested in and click 'Edit'. You need write access to the repo to use Prose.

Meta data can be edited on Prose by using one of the buttons on the far right.

## Editing Locally

<div class="box-info"><i class="fa fa-info-circle"></i>This method requires a certain amount of technical knowledge.</div>

This is the more complicated option, the benefits are you can use a desktop text editor and run the entire site on your machine to preview changes before they go live. You should have knowledge of Git and the command line to do this.

Dependences of this site are managed with [Bundler](http://bundler.io/), install it if you haven't got it already and just do `bundle install`.

To get Jekyll up and running do `bundle exec jekyll serve --watch`, the site will then be available on <http://localhost:4000>.

## Syntaxes Used

A combination of HTML and Markdown (Kramdown variant) is used for marking up our pages. YAML is used for meta data and is documented for shows, committees etc here.

The [Kramdown syntax guide](http://kramdown.gettalong.org/syntax.html) is useful for reference.
