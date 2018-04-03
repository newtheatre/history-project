---
layout: docs
group: docs
title: Shows
order: 20
redirect_from:
  - /docs/shows/index.html
---

The show records are stored as `_shows/YY_YY/show_name.md` with YY_YY being the academic year 'span'. The synopsis is the content of the page, i.e. goes after the attribute section.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.show %}

## <i class="octicon octicon-code"></i> Example Show

{% highlight yaml %}
---
title: The Pillowman
playwright: Martin McDonagh
season: In House
season_sort: 70
period: Autumn
venue: New Theatre
date_start: 2012-12-12
date_end: 2012-12-15

canonical:
- title: The Pillowman
  playwright: Martin McDonagh

cast:
  - role: Katurian
    name: Sam Haywood
  - role: Ariel
    name: Will Randall
crew:
  - role: Director
    name: James McAndrew
  - role: Producer
    name: Nick Stevenson

award:
  - title: Best National Show 
    org: The National  
    year: 2013

prod_shots: abcd123

assets:
  - type: poster
    image: XJZCPfW
  - type: flyer
    image: XKsW92t
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme

tour:
  - venue: The National
    date_start: 2013-01-01
    date_end: 2013-01-03
    notes: Show won award
---

In an unnamed police state, a writer has been arrested because the content of his stories bares a striking resemblance to a series of gruesome child murders. Interrogated by two brutal detectives, he claims to know nothing of such murders. But also in their custody is his younger, brain damaged brother, who perhaps knows more than he first lets on. A darkly comic thriller like no other.
{% endhighlight %}

