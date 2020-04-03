---
layout: docs
group: docs
title: Key Events
order: 39
---

The History page gatheres its list of events from `data/history.yaml`. When attached to single years, these events are also displayed on that year's page.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.key-events %}

## <i class="octicon octicon-code"></i> Example History Entry

{% highlight yaml %}
- year: 2001
  academic_year: "01_02" 
  title: A New Foyer
  description: "Thanks to a gracious alumni donation, we were able to fund the construction of our foyer. This housed internal access to the Box Office, toilets, and bar. Its glass exterior created a fresh and open environment for all visitors."
  image:
    href: https://photos.newtheatre.org.uk/2011-12/Matthew-Bannister-Visit-2012/i-VgSsh2w/0/M/428161_10150669394401460_1300692780_n-M.jpg
    alt: First foyer
{% endhighlight %}
