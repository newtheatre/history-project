---
layout: docs
group: docs
title: Photos and Assets
sort: 100
---

Show records currently have a *'Publicity Materials'* and *'Production Shots'* section. All images are stored in the [New Theatre SmugMug](https://photos.newtheatre.org.uk), other binaries are stored in the repo's `assets/for_shows/` folder.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `type` | Type of asset | The type of asset, the first of type *poster* will be used as the show's poster. List non-exhaustive, should be lowercase: *photo, poster, flyer, programme*. |
| `image`<br />*(semi-optional)*| The SmugMug ID of the image | Find IDs using the [show asset utility](/util/smug-show-assets/). |
| `filename`<br />*(semi-optional)* | If non-image (PDF etc) the filename | Will look under `assets/for_shows/`. |
| `title`<br />*(optional)* | Asset title | Is shown when graphical representation of file is not possible, required for PDF files and similar. |
| `caption`<br />*(image only, optional)* | Image caption | Is shown when image is clicked on to make big. |
| `page`<br />*(optional)* | Orders within a type, should be a number | For type programme it is the page number where the front page is `1`, for a single page flyer the front would be `1` and the back `2`. Shouldn't be required for multipage files such as PDFs. |
| `display_image`<br />*(optional)* | If `true` sets asset as display image | Overrides the order of precedence in selecting a show's display image. Ensure asset is an image. |

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

