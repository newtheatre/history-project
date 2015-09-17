---
layout: docs
group: docs
title: Photos and Assets
sort: 100
---

Show records currently have a *'Publicity Materials'* and *'Production Shots'* section. In the show's data file production shots are kept in a list called `photos`, and publicity materials in `assets`.

The image files themselves are kept in the `images/for_shows/` folder whereas anything else (PDFs etc) are kept in `assets/for_shows/`.


## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `type` | Type of asset | The type of asset, the first of type *poster* will be used as the show's poster. List non-exhaustive, should be lowercase: *photo, poster, flyer, programme*. |
| `image`<br />*(semi-optional)*| If image (JPG, PNG) the filename | Will look under `images/for_shows/`. |
| `filename`<br />*(semi-optional)* | If non-image (PDF etc) the filename | Will look under `assets/for_shows/`. |
| `caption`<br />*(image only, optional)* | Image caption | Is shown when image is clicked on to make big. |
| `page`<br />*(optional)* | Orders within a type, should be a number | For type programme it is the page number where the front page is `1`, for a single page flyer the front would be `1` and the back `2`. |

## <i class="octicon octicon-code"></i> Example

{% highlight yaml %}
photos:
  - type: photo
    image: pillowman_crew.jpg
    caption: "Cast and Crew shot. From back left: Jess Courtney, Gareth Morris, Livvy Hobson, Daniel O'Connor, Charlotte Ball, Jacob Hayes, James McAndrew, Nick Stevenson, Chelsea Jayne Wright, Emily Heaton. Bottom from left: Sam Haywood, Will Randall, Alex Hollingsworth"

assets:
  - type: poster
    image: pillowman_poster.jpg
  - type: flyer
    image: pillowman_flyer_1.png
    page: 1
  - type: flyer
    image: pillowman_flyer_2.png
    page: 2
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme
{% endhighlight %}

## <i class="fa fa-upload"></i> Uploading

<div class="box-error">This needs writing up.</div>

Uploading images and assets needs to be done using Git directly. GUI clients for [Windows](https://windows.github.com/) and [Mac](https://mac.github.com/) are avaliable.
