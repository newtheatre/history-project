---
layout: docs
group: docs
title: Editing
sort: 10
---

To edit the site you have several options. To make direct edits you must be added as a trusted editor to the [repository](http://github.com/newtheatre/history-project) by an [owner](https://github.com/orgs/newtheatre/people) however you can propose edits straight away for an editor to merge in.

## Editing Online

You can either use the GitHub website, Prose or using a text editor on your computer. Either way you'll need a free GitHub account, you can [sign up here](https://github.com/join).

Ensure you have a verified email address with GitHub otherwise your changes will not trigger a build.

### GitHub

<iframe class="youtube" src="https://www.youtube.com/embed/yC2aBvMgTzg?showinfo=0&color=white&modestbranding=1" frameborder="0" allowfullscreen></iframe>

To use the GitHub website use the <strong class="tag"><i class="octicon octicon octicon-pencil"></i> Improve This Page</strong> button on the right hand edge of a page to launch the editor.

If you're not a trusted editor you'll be prompted to create a _fork_ and will be led through the process of creating a pull request. Later an editor will check your changes are valid and merge them into the repo.

### Prose

<div class="box-warning">

<i class="fa fa-exclamation-triangle"></i> You'll need write access to the repo to use Prose.

</div>

[Prose](http://prose.io) is a bit nicer to use when doing a lot of editing. Visit the site and authorise with GitHub. Find the history-project repo to load up the file list. Navigate to the file you're interested in and click 'Edit'.

Meta data can be edited on Prose by using one of the buttons on the far right, a preview should also be available.

## Editing Locally

<div class="box-info"><i class="fa fa-info-circle"></i>This method requires a certain amount of technical knowledge.</div>

This is the more complicated option, the benefits are you can use a desktop text editor and run the entire site on your machine to preview changes before they go live. You should have knowledge of Git and the command line to do this.

See [README.md](https://github.com/newtheatre/history-project/blob/master/README.md) for up to date install instructions.

Getting the site running on your machine locally is easy to do on Mac and Linux. It _can_ be done on Windows, but it's tricky. The website [Run Jekyll on Windows](http://jekyll-windows.juthilo.com/) has a full tutorial on how to do this.

## Syntaxes Used

A combination of HTML and Markdown (Kramdown variant) is used for marking up our pages. YAML is used for meta data and is documented for shows, committees etc here.

The [Kramdown syntax guide](http://kramdown.gettalong.org/syntax.html) is useful for reference.
