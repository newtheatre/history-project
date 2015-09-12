---
layout: docs
group: docs
title: Person List
sort: 90
---

A person list is a format for storing a list of roles and names. They are used for various records on this site.

A role or name flagged as unknown will be styled differently and a warning will show above the list asking for help.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `role` | Corresponds to name of a role (acting, crew) or position (committee). | To flag as unknown set to 'unknown'. |
| `name` | The person's name. | Formatted `FirstName LastName`. To flag as unknown set to 'unknown'. |
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
