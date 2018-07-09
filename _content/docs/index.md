---
layout: docs
group: docs
title: Site Documentation
order: 1
permalink: /docs/
---

The aim of the backend of this site to to strike a balance between making a powerful site and making that site easy to edit and maintain. For the bits that aren't that easy here's the documentation!

## Technical Summary

The source for this site is kept in a [GitHub repository](https://github.com/newtheatre/history-project), this keeps a full history of all changes and allows broad collaboration.

Pages, layouts and styling is all kept in plain text. The [Jekyll](http://jekyllrb.com) static site generator - which runs on every authorised change from a [Travis CI](https://travis-ci.org/newtheatre/history-project) build - then turns the constituent parts of the project into the built site in front of you. The built site is hosted from a separate repository by the [GitHub Pages](https://pages.github.com/) service.

## Super Secret Editors' Mode

If you type the word **editor** - go on try it - while this site is active you'll enable a secret editors' / debuggy mode. Extra (ugly) content will be shown - for example show counts next to years on the [archive page](/years/). If these items seem a bit cryptic hover over them and hope someone left a tooltip description.

With editors' mode enabled the 'Improve this page' dialogue is bypassed.
