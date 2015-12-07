---
layout: about
group: about
current: about
title: About This Site
published: true
---


# <i class="octicon octicon-circuit-board"></i> {{ page.title }}

This site is an initiative of the [Nottingham New Theatre Alumni Network](http://newtheatre.org.uk/alumni) and aims to piece together the New Theatre’s dynamic and vibrant history.

This is an extremely exciting project for the network, and we are relying on as many people as possible getting involved and contributing to the story – whether you were an actor, a director, a stage-manager or an audience member, we want you to get in touch with your memories from your time at the theatre.

In particular we are looking for: listings of season shows, casts and crew lists, photographs, programmes, flyers, reviews and anything else which could provide an insight into the history of the theatre.

See the [contributing](/contributing/) section for details on how to help out.

<div class="grid-row">

<div class="grid-8" markdown="1">

## People

- **Project Lead:** Phil Geller
- **Development Lead:** Will Pimblett

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
