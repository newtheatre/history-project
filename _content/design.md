---
layout: default
title: Design
search: false
sitemap: false
---

<div class="wrapper" markdown="1">

# Design Test

Lorem ipsum **dolor sit strong amet**, consectetur adipiscing elit. Nullam tempus magna id dui mollis dignissim. Donec malesuada dolor eget suscipit ullamcorper. *Proin emphasis facilisis* leo quis tellus porta, faucibus malesuada nisl ornare. Cras sed risus accumsan, maximus felis vitae, efficitur risus. Phasellus ornare malesuada urna, sit amet <a data-proofer-ignore href="">mid paragraph link</a> varius massa pulvinar et. Cras molestie sodales nulla vitae feugiat. Donec efficitur nisl dui, ut faucibus nisi interdum nec. Nullam fermentum in sapien quis tincidunt. Etiam hendrerit maximus augue, ut vestibulum quam posuere nec. Suspendisse non nunc ut tortor consectetur tristique. Quisque rutrum diam in justo accumsan volutpat sed sed ligula.

## Header 2

Vestibulum accumsan <strong><em>placerat strong em malesuada</em></strong>. Nulla at nisl varius ex pretium consequat mollis non ante.

### Header 3

Etiam pharetra ac felis non sodales. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas ultrices facilisis est, ut pharetra velit sodales vitae.

#### Header 4

Etiam vel purus lobortis, suscipit dolor in, laoreet leo. Nam lorem lectus, molestie sed risus vitae, tincidunt feugiat leo.

##### Header 5

Sed quam ante, iaculis eget magna eu, semper rhoncus lacus.

###### Header 6

Sed sit amet nibh lorem. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse eleifend sagittis tellus sit amet lacinia.

  - Unordered list item
  - Bob
  - Alice
  - Eve

</div>

<div class="wrapper" markdown="1">

## Buttons

<a href="#0" data-proofer-ignore class="button">A button</a>
<a href="#0" data-proofer-ignore class="button button-search">A button</a>
<a href="#0" data-proofer-ignore class="button button-improve">A button</a>
<a href="#0" data-proofer-ignore class="button button-delete">A button</a>
<a href="#0" data-proofer-ignore class="button button-complete">A button</a>

<p>Paragraph here</p>

</div>

<div class="wrapper" markdown="1">

## Boxes

  <div class="box-error">
    <i class="fa fa-ban"></i>
    <p><strong>Error!</strong> Uh-oh, something is wrong. I'm a <a data-proofer-ignore href="">Link</a>.</p>
  </div>
  <div class="box-warning">
    <i class="fa fa-exclamation-triangle"></i>
    <p><strong>Warning!</strong> Hmm, something's not quite right. I'm a <a data-proofer-ignore href="">Link</a>.</p>
  </div>
  <div class="box-success">
    <i class="ion-checkmark"></i>
    <p><strong>Yipee!</strong> Yeah, something is successful. I'm a <a data-proofer-ignore href="">Link</a>.</p>
  </div>
  <div class="box-info">
    <i class="fa fa-info-circle"></i>
    <p><strong>Hey</strong> Here's some info. I'm a <a data-proofer-ignore href="">Link</a>.</p>
  </div>
  <div class="box-debug">
    <i class="ion-bug"></i>
    <p><strong>Debug!</strong> Here's some debug output. I'm a <a data-proofer-ignore href="">Link</a>.</p>
  </div>


</div>

<div class="wrapper" markdown="1">

## Tables

| Column | Another Column | More Columns |
|:-|:-|:-|
| Row | Person name. | In the format Firstname Lastname. |
| `gender` | Person gender. | Recognises `male` or `female`. |
| `headshot` | Filename of a photo. | Will look in the `images/people/` directory. Filename should be `firstname_lastname.jpg`. |
| `course` | The course, or courses the person studied. | Can be a single value or a list if multiple courses studied. |
| `graduated` | The year the person graduated. | YYYY |
| `award`<br />*(optional)* | Award person received on leaving the theatre. | Should be in title case, Fellowship, Commendation. If not applicable line should be omitted. |
| `careers` | List of careers, theatre or non-theatre related. | Recognised theatre careers are listed in [_data/careers.yaml](https://github.com/newtheatre/history-project/blob/master/_data/careers.yaml). |
| `links` | A [link list](/docs/link-list) to external profiles and other sites. | Should implement `type`, and `href`, can optionally use `title`. Common types are listed in [_data/link-types.yaml](https://github.com/newtheatre/history-project/blob/master/_data/link-types.yaml). |
| `news` | A [link list](/docs/link-list) to news stories. | For collecting notable news stories relating to the alumnus. Should implement `title`, `date` and `href`. |
| `comment` | Reserved for editor comments, only displayed in [editors' mode](/docs/#super-secret-editors-mode). |

</div>
