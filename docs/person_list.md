---
layout: docs
group: docs
title: Person List
sort: 90
---

A person list is a format for storing a list of roles and names. They are used for various records on this site.

## Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `role` | Corresponds to name of a role (acting, crew) or position (committee). |  |
| `name` | The person's name. | Should be formatted `FirstName LastName`. |
| `note` *(optional)* | An optional note. | Currently this is shown in brackets after the role when rendered. |

## Example Person List

{% highlight yaml %}
list:
  - role: Katurian
    name: Sam Haywood
  - role: Ariel
    name: Will Randall
    note: Something
{% endhighlight %}
