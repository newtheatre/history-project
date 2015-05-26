---
layout: about
group: about
current: about
title: About This Site
sort: 10
---

# <i class="octicon octicon-circuit-board"></i> {{ page.title }}

This site is an initiative of the [New Theatre Alumni Network](http://newtheatre.org.uk/alumni).

## People

- Will Pimblett
- Phil Geller

## Build Details

{% assign shows = site.collections.shows.docs %}
{% assign committees = site.collections.committees.docs %}

- Site last updated at {{site.time | date: "%Y-%m-%d %H:%M" }}
- Build number {% include travis_build_number.txt %}.
- {{shows.size}} shows and {{committees.size}} committees.
