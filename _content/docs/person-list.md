---
layout: docs
group: docs
title: Person List
sort: 90
redirect_from: /docs/person_list/index.html
---

A person list is a format for storing a list of roles and names used for various records on this site. Person lists are used to link people with shows and committees in addition to populating the people collection.

A role or name flagged as unknown will be styled differently and a warning will show above the list asking for help.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.person-list %}

## <i class="octicon octicon-code"></i> Example Person List

{% highlight yaml %}
list:
  - role: Katurian
    name: Sam Haywood
  - role: Ariel
    name: Will Randall
    note: Something
{% endhighlight %}
