---
layout: docs
group: docs
title: People
order: 35
redirect_from:
  - /docs/people/index.html
---

<div class="box-warning">
  <i class="fa fa-exclamation-triangle"></i> We haven't fully defined the person data type, breaking changes may still be made.
</div>

Biographies of theatre alumni are stored as `_people/firstname_lastname.md`.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.person %}

## <i class="octicon octicon-code"></i> Example Person

{% highlight yaml %}
---
title: John Smith
gender: male
headshot: ABC123
course: BEng Mechanical Engineering
graduated: 2010
careers:
  - Lighting Designer
links:
  - type: Personal Website
    href: "https://johnsmith.com"
news:
  - title: John Smith Best Lighting Design Ever
    type: Article
    date: 2014-01-01
    href: "https://chorleychronicle.info/johnsmith"
---

John did techie stuff

{% endhighlight %}

{% highlight yaml %}
---
title: Alice Smith
gender: female
headshot: ABC124
course:
  - Creative Writing BA
  - English MA
graduated: 2015
award: Commendation
careers:
  - Finance
---

Alice did acting

{% endhighlight %}
