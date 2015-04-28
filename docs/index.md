---
layout: docs
group: docs
title: Site Documentation
sort: 5
---

The aim of the backend of this site to to strike a balance between making a powerful site and making that site easy to edit. For the bits that aren't that easy here's the documentation!

## Technical Summary

The source for this site is kept in a [GitHub repository](https://github.com/newtheatre/history-project), this keeps a full history of all changes and allows broad collaboration.

Pages, layouts and styling is all kept in plain text. The [Jekyll](http://jekyllrb.com) static site generator - which runs on every authorised change from a [Travis CI](https://travis-ci.org/newtheatre/history-project) build - then turns the constituent parts of the project into the built site in front of you. The built site is hosted from the `gh-pages` branch of the repo by the  [GitHub Pages](https://pages.github.com/) service.
