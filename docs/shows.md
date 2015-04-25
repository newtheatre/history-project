---
layout: docs
group: docs
title: Shows
sort: 20
---

This site aims to collect much information about past shows of the New Theatre.

The show records are stored as `_shows/YY_YY/show_name.md` with YY_YY being the academic year 'span'.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `layout` | Page layout | Sets the layout for the page, should always be set to `show`. |
| `title` | Show title | Displayed at the top of the show page and on various other pages. |
| `playwright` | Full name of the playwright |  |
| `student_written` | Show written by an NT member | Set to `true`, `false` or line missing are equivalent. |
| `season` | Season show belongs to | Choices: Autumn, Spring, Edinbugh |
| `season_sort` | Order which this show comes in the entire year in a multiple of 10. | i.e. The Pillowman was the 7th show in the season, so the sort is 70. |
| `year` | Year this show belongs to in the format YY_YY | i.e. The Pillowman was performed in the 2012-13 academic year so the year is "12_13" |
| `venue` | Venue show was performed in. | There should only be one item in this list. |
| `date_start` | Date of first performance | In the format YYYY-MM-DDD |
| `date_end` | Date of last performance | In the format YYYY-MM-DDD |
| `cast` | Cast members | Uses the [person list](/docs/person_list) format. |
| `crew` | Crew members | Uses the [person list](/docs/person_list) format. |
| `photos` | Production shots | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `assets` | Publicity and other materials | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `published` | *Not yet used!* Will in the future hide the show if set to false. |
| `comments` | Reserved for editor comments, will **never** show up on the live site. |


## <i class="octicon octicon-code"></i> Example Show

{% highlight yaml %}
---
layout: show
title: The Pillowman
playwright: Martin McDonagh
season: In House
season_sort: 70
year: "12_13"
period: Autumn
venue:
  - New Theatre
date_start: 12/12/2012
date_end: 15/12/2012
cast:
  - role: Katurian
    name: Sam Haywood
  - role: Ariel
    name: Will Randall
crew:
  - role: Director
    name: James McAndrew
  - role: Producer
    name: Nick Stevenson
photos:
  - type: photo
    image: pillowman_crew.jpg
    caption: "Cast and Crew shot. From back left: Jess Courtney, Gareth Morris, Livvy Hobson, Dan O'Connor, Charlotte Ball, Jacob Hayes, James McAndrew, Nick Stevenson, Chelsea Jayne Wright, Emily Heaton. Bottom from left: Sam Haywood, Will Randall, Alex Hollingsworth"
assets:
  - type: poster
    image: pillowman_poster.jpg
  - type: flyer
    image: pillowman_flyer_2.png
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme

published: true
---
{% endhighlight %}

