---
layout: docs
group: docs
title: Person List
sort: 90
---

A person list is a format for storing a list of roles and names. They are used for various records on this site.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `role` | Corresponds to name of a role (acting, crew) or position (committee). | Can be set to `unknown` which will tag the role as unknown. |
| `name` | The person's name. | Formatted `FirstName LastName`. Can be set to `unknown` which will tag the name as unknown. |
| `note` *(optional)* | An optional note. | Currently this is shown in brackets after the role when rendered. |

## <i class="octicon octicon-code"></i> Example Person List

{% highlight yaml %}
list:
  - role: Katurian
    name: Sam Haywood
  - role: Ariel
    name: Will Randall
    note: Something
{% endhighlight %}
