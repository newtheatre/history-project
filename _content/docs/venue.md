---
layout: docs
group: docs
title: Venues
order: 38
redirect_from:
  - /docs/venues/index.html
---

Venue data is stored as `_venues/venue-name.md`. The content is the venue description.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.venue %}

## <i class="octicon octicon-code"></i> Example Venue

{% highlight yaml %}
---
title: Lincoln Library
built: 1962
images:
  - 5rTvvrw
location:
  lat: 52.9419
  lon: -1.1995
links:
	- type: default
		title: Lincoln Hall Website
		href: http://www.nottinghamconferences.co.uk/lincoln-hall/
	- type: Twitter 
		title: @LincolnLibrary
		username: LincolnLibrary
---

Lincoln Library, also called Coveney Library, is a hall library located directly north of the New Theatre.
{% endhighlight %}
