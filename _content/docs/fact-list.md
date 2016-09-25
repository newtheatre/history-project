---
layout: docs
group: docs
title: Fact List
sort: 98
---

A fact list is a standard format for representing a list of 'fun facts' used in various places on the site.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.fact-list %}

## <i class="octicon octicon-code"></i> Example Fact List

{% highlight yaml %}
facts:
  - fact: Every character in this play was portrayed by a perfectly 
          circular Victoria Sponge.
    name: Fred Bloggs
    submitted: 2016-01-01
    
{% endhighlight %}
