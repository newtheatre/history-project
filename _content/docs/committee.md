---
layout: docs
group: docs
title: Committees
sort: 30
redirect_from: 
  - /docs/committees/
---

Committee listings are stored as `_committees/YY_YY.md` with YY_YY being the academic year 'span'.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.committee %}

## <i class="octicon octicon-code"></i> Example Committee

{% highlight yaml %}
---
title: 2012-13

committee:
  - role: President
    name: Sam Hayward
  - role: Treasurer
    name: Nick Stevenson
  - role: Theatre Manager
    name: James Bentley

comment: "Pretty sure there were more members!"
---
{% endhighlight %}
