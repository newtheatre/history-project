---
layout: docs
group: docs
title: Photos and Assets
order: 100
redirect_from: /docs/photos_and_assets/index.html
---

Show records currently have a *'Publicity Materials'* and *'Production Shots'* section. All images are stored in the [New Theatre SmugMug](https://photos.newtheatre.org.uk), other binaries are stored in the repo's `assets/for_shows/` folder.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.assets %}

## <i class="octicon octicon-code"></i> Example

{% highlight yaml %}
assets:
  - type: poster
    image: XJZCPfW
  - type: flyer
    image: XKsW92t
    page: 1
  - type: flyer
    image: XKsW92u
    page: 2
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme
{% endhighlight %}

