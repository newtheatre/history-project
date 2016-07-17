---
layout: docs
group: docs
title: Venues
sort: 38
---

Venue data is stored as `_venues/venue-name.md`. The content is the venue description.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `title` | Venue title | Should match usage with shows, if using `venue_sort` should match that. Must also match filename. |
| `built` | Year the venue was constructed. | YYYY |
| `images` | List of SmugMug image IDs of the venue. | Find IDs using [venue utility](/util/smug-venues/). |
| `location` | Exact location of the venue, two child attibutes `lat` and `lon` as decimals. | Used for map marker. |
| `comment` | Reserved for editor comments, only displayed in [editors' mode](/docs/#super-secret-editors-mode). |

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
---

Lincoln Library, also called Coveney Library, is a hall library located directly north of the New Theatre.
{% endhighlight %}
