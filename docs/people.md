---
layout: docs
group: docs
title: People
sort: 35
---

<div class="box-warning">
  <i class="fa fa-exclamation-triangle"></i> We haven't fully defined the person data type, breaking changes may still be made.
</div>

Biographies of theatre alumni are stored as `_people/firstname_lastname.md`.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `title` | Person name. | In the format Firstname Lastname. |
| `gender` | Person gender. | Recognises `male` or `female`. |
| `headshot` | Filename of a photo. | Will look in the `images/people/` directory. Filename should be `firstname_lastname.jpg`. |
| `course` | The course, or courses the person studied. | Can be a single value or a list if multiple courses studied. |
| `graduated` | The year the person graduated. | YYYY |
| `award`<br />*(optional)* | Award person received on leaving the theatre. | Should be in title case, Fellowship, Commendation. If not applicable line should be omitted. |
| `careers` | List of careers, theatre or non-theatre related. | Recognised theatre careers are listed in [_data/careers.yaml](https://github.com/newtheatre/history-project/blob/master/_data/careers.yaml). |
| `links` | A [link list](/docs/link-list) to external profiles and other sites. | Should implement `type`, and `href`, can optionally use `title`. Common types are listed in [_data/link-types.yaml](https://github.com/newtheatre/history-project/blob/master/_data/link-types.yaml). |
| `news` | A [link list](/docs/link-list) to news stories. | For collecting notable news stories relating to the alumnus. Should implement `title`, `date` and `href`. |
| `comment` | Reserved for editor comments, only displayed in [editors' mode](/docs/#super-secret-editors-mode). |


## <i class="octicon octicon-code"></i> Example Person

{% highlight yaml %}
---
title: John Smith
gender: male
headshot: john_smith.jpg
course: BEng Mechanical Engineering
graduated: 2010
careers:
  - Lighting Designer
links:
  - type: Personal Website
    href: "http://johnsmith.com"
news:
  - title: John Smith Best Lighting Design Ever
    type: Article
    date: 2014-01-01
    href: "http://chorleychronicle.info/johnsmith"
---

John did techie stuff

{% endhighlight %}

{% highlight yaml %}
---
title: Alice Smith
gender: female
headshot: alice_smith.jpg
course:
  - Creative Writing BA
  - English MA
graduated: 2015
award: Commendation
careers:
  - Finance
---

Alice did acting

{% endhighlight %}
