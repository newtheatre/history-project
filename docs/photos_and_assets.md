---
layout: docs
group: docs
title: Photos and Assets
sort: 100
---

Photos and assets are stored in either the `images/` or `assets/` folders.

## Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `type` | Type of asset | The type of asset, the first of type poster will be used as the show's poster. |
| `image` *(semi-optional)*| If image (JPG, PNG) the filename | Will look under `images/for_shows/` |
| `filename` *(semi-optional)* | If non-image (PDF etc) the filename | Will look under `assets/for_shows/` |
| `caption` *(image only, optional)* |  |  |

## Example

{% highlight yaml %}
photos:
  - type: photo
    image: pillowman_crew.jpg
    caption: "Cast and Crew shot. From back left: Jess Courtney, Gareth Morris, Livvy Hobson, Dan O'Connor, Charlotte Ball, Jacob Hayes, James McAndrew, Nick Stevenson, Chelsea Jayne Wright, Emily Heaton. Bottom from left: Sam Haywood, Will Randall, Alex Hollingsworth"
assets:
  - type: poster
    image: pillowman_poster.jpg
  - type: flyer
    image: pillowman_flyer_2.png
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme
{% endhighlight %}

## Uploading

<div class="box-error">This needs writing up.</div>

Uploading images and assets needs to be done by a desktop Git application.
