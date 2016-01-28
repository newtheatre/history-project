---
layout: docs
group: docs
title: Shows
sort: 20
---

The show records are stored as `_shows/YY_YY/show_name.md` with YY_YY being the academic year 'span'. The synopsis is the content of the page, i.e. goes after the attribute section.

## <i class="fa fa-tags"></i> Attribute Reference

| Attribute | Job | Description |
|:-|:-|:-|
| `title` | Show title | Displayed at the top of the show page and on various other pages. |
| `playwright`<br />*(semi-optional)* | Full name of the playwright | Omit if using `devised`, set to `various` if compilation. |
| `devised`<br />*(semi-optional)* | Used if play was devised | Either `true` for generic output or a descriptor. Example descriptor: `"Cast and Crew"` will output "Devised by Cast and Crew". Omit if using `playwright`. |
| `adaptor`<br />*(optional)* | Full name of adaptor | Outputs as "Adapted by adaptor" |
| `translator`<br />*(optional)* | Full name of the translator | Outputs as "Translated by translator" |
| `student_written`<br />*(optional)* | Show written by an NT member | Set to `true`, `false` or line missing are equivalent. |
| `company`<br />*(optional)* | If non-NNT the name of the company |  |
| `season` | Season show belongs to | Choices: Autumn, Spring, Edinbugh |
| `season_sort` | Order which this show comes in the entire year | Use multiples of 10 for ease of additions.<br />Roughly: Autumn should start at 30, Spring 200 and Edinburgh 400. Shows then fall at 30, 40, 50 etc |
| `venue` | Venue show was performed in |  |
| `date_start` | Date of first performance | In the format YYYY-MM-DD |
| `date_end`<br />*(optional)* | Date of last performance | In the format YYYY-MM-DD, omit if show only ran one day |
| `cast` | Cast members | Uses the [person list](/docs/person_list) format. |
| `crew` | Crew members | Uses the [person list](/docs/person_list) format. |
| `smugmug`<br />*(optional)* | SmugMug album ID for production shots | Use the [API explorer](https://www.smugmug.com/api/v2/user/newtheatre!albums?count=5000) to find the ID. |
| `photos`<br />*(optional)* | Production shots **(depreciated)** | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `assets`<br />*(optional)* | Publicity and other materials | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `published` | *Not yet used!* | Will in the future hide the show if set to false. |
| `comment`<br />*(optional)* | Reserved for editor comments | Displayed in [editors' mode](/docs/#super-secret-editors-mode). |


## <i class="octicon octicon-code"></i> Example Show

{% highlight yaml %}
---
title: The Pillowman
playwright: Martin McDonagh
season: In House
season_sort: 70
period: Autumn
venue: New Theatre
date_start: 2012-12-12
date_end: 2012-12-15
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

smugmug: abcd123

assets:
  - type: poster
    image: pillowman_poster.jpg
  - type: flyer
    image: pillowman_flyer_2.png
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme

---

In an unnamed police state, a writer has been arrested because the content of his stories bares a striking resemblance to a series of gruesome child murders. Interrogated by two brutal detectives, he claims to know nothing of such murders. But also in their custody is his younger, brain damaged brother, who perhaps knows more than he first lets on. A darkly comic thriller like no other.
{% endhighlight %}

