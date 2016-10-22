---
layout: docs
group: docs
title: Link List
order: 95
---

<div class="box-warning">
  <i class="fa fa-exclamation-triangle"></i> We haven't fully defined the link list data type, breaking changes may still be made.
</div>

A link list is a standard format for representing a list of external resources used in various places on the site.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.link-list %}

## <i class="fa fa-archive"></i> Archiving Resources

Linking to many online resources as part of a long-term project is risky. Websites may close or re-arrange their URLs rendering our links broken. To protect against this editors should create snapshots of resources when they link to them. These snapshots save the state of those resources at a single point in time. Unless the archiving service closes we should have a permanent record of all resources with snapshots.

We currently use [archive.is](https://archive.is/) to create snapshots. Snapshots are created by entering the URL of the resource to be saved on the archive.is website. A page will be returned with a five-character reference code in the URL. For example archiving example.com returns page whose URL is `https://archive.fo/oYs92`, the reference code is `oYs92`. This code should be placed in the `snapshot` attribute of the link list item.

## <i class="octicon octicon-code"></i> Example Link List

{% highlight yaml %}
links:
  - type: Example Domain
    href: "https://example.com"
    snapshot: oYs92
    title: Example Domain
  - type: News Story
    href: "https://news.com/a-story"
    snapshot: abc12
    title: A Story
    date: 1980-01-01
    quote: "A very interesting quotation."
{% endhighlight %}
