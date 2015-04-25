---
layout: docs
group: docs
title: Committees
sort: 30
---

Committee listings are stored as `_committees/YY_YY.md` with YY_YY being the academic year 'span'.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `layout` | Page layout | Sets the layout for the page, should always be set to `committee`. |
| `title` | Page title | Used to set the title of the page, should be in the format YYYY-YY. |
| `year` | Year this committee belongs to in the format YY_YY | i.e. for the 2012-13 academic year the year is "12_13" |
| `committee` | A [person list](/docs/person_list) for the committee |  |
| `comments` | Reserved for editor comments, will **never** show up on the live site. |


## <i class="octicon octicon-code"></i> Example Committee

{% highlight yaml %}
---
layout: committee

title: 2012-13
year: "12_13"

committee:
  - role: President
    name: Sam Hayward
  - role: Treasurer
    name: Nick Stevenson
  - role: Theatre Manager
    name: James Bentley

---
{% endhighlight %}
