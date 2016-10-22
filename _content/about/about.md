---
layout: about
group: about
current: about
title: About This Site
order: 10
permalink: /about/
---


# <i class="octicon octicon-circuit-board fa-fw"></i> {{ page.title }}

This site is an initiative of the [Nottingham New Theatre Alumni Network](http://newtheatre.org.uk/alumni) and aims to piece together the New Theatre’s dynamic and vibrant history.

This is an extremely exciting project for the network, and we are relying on as many people as possible getting involved and contributing to the story – whether you were an actor, a director, a stage-manager or an audience member, we want you to get in touch with your memories from your time at the theatre.

In particular we are looking for: listings of season shows, casts and crew lists, photographs, programmes, flyers, reviews and anything else which could provide an insight into the history of the theatre.

See the [contributing](/contributing/) section for details on how to help out.

<div class="grid-row">

<div class="grid-8" markdown="1">

## People

- **Project Lead:** Phil Geller
- **Development Lead:** Will Pimblett
- **Editor:** Nathan Penney
- **Editor:** Nick Stevenson

</div>
<div class="grid-8" markdown="1">

## Build Details

{% assign shows = site.shows %}
{% assign committees = site.committees %}
{% assign people = site.people %}

- Site last updated at {{site.time | date: "%Y-%m-%d %H:%M" }}
- Build number {% include travis_build_number.txt %}.
- {{shows.size}} shows, {{committees.size}} committees and {{people.size}} people.

</div>

</div>

## Special Thanks

- Browser testing tools generously provided by [BrowserStack](https://www.browserstack.com/).
- Mapping © <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>

## Open codebase

The entire codebase used to build this website is available on [GitHub](https://github.com/newtheatre/history-project). While the project as a whole isn't particularly helpful for other organizations, what we're doing here can be described as [*coding in the open*](https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/), rather than building an open source project. That said parts of the project may be of interest or use to others. This repository is a mix of source and content, as such there are two licences that apply.

- All source files (HTML templates, Sass, CoffeeScript, Ruby, shell scripts) are released under the [MIT licence](https://opensource.org/licenses/MIT).
- All content files (HTML files, Markdown, YAML datafiles, images, graphics) are copyright © The Nottingham New Theatre 2016.
