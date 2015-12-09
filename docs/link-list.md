---
layout: docs
group: docs
title: Link List
sort: 95
---

<div class="box-warning">
  <i class="fa fa-exclamation-triangle"></i> We haven't fully defined the link list data type, breaking changes may still be made.
</div>

A link list is a format for representing a list of external links used in various places on the site.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `href` | URL of the resource. | Should be wrapped in quotes. |
| `type` | Type of the resource. | Non-exhaustive common types are listed in [_data/link-types.yaml](https://github.com/newtheatre/history-project/blob/master/_data/link-types.yaml). |
| `title` | Title of the resource, useful for headlines. | Only include if suitable. |
| `date` | Date resource was published, relevant to news stories. | Formatted YYYY-MM-DD. Only include if suitable. |
| `comment` | Reserved for editor comments, only displayed in [editors' mode](/docs/#super-secret-editors-mode). |

## <i class="octicon octicon-code"></i> Example Link List

{% highlight yaml %}
links:
  - href: "http://example.com"
    type: Example
    title: Example Site
  - href: "http://news.com/a-story"
    type: News Story
    title: A Story
    date: 1980-01-01
{% endhighlight %}
