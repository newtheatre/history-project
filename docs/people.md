---
layout: docs
group: docs
title: People
sort: 35
---

<div class="box-warning">
  <i class="fa fa-exclamation-triangle"></i> We haven't fully defined the person data type, breaking changes may still me made.
</div>

Biographies of theatre alumni are stored as `_people/firstname_lastname.md`.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `title` | Person name. | In the format Firstname Lastname. |
| `headshot` | Filename of a photo. | Will look in the `images/people/` directory. Filename should be `firstname_lastname.jpg`. |
| `course` | The course, or courses the person studied. | Can be a single value or a list if multiple courses studied. |
| `graduated` | The year the person graduated. | YYYY, if multiple courses |
| `award`<br />*(optional)* | Award person received on leaving the theatre. | Should be in title case, Fellowship, Commendation. If not applicable line should be omitted. |
| `comments` | Reserved for editor comments, only displayed in [editors' mode](/docs/#super-secret-editors-mode). |


## <i class="octicon octicon-code"></i> Example Person

{% highlight yaml %}
---
title: John Smith
headshot: john_smith.jpg
course: BEng Mechanical Engineering
graduated: 2010
---

John did techie stuff

{% endhighlight %}

{% highlight yaml %}
---
title: Alice Smith
headshot: alice_smith.jpg
course:
  - Creative Writing BA
  - English MA
graduated: 2015
award: Commendation
---

Alice did acting

{% endhighlight %}
