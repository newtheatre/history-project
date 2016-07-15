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
| `title` | Show title | Displayed at the top of the show page and on various other pages. Should be the title of this performance, may not quite match the title of the play – see `canonical`. |
| `playwright`<br />*(semi-optional)* | Full name of the playwright | Omit if using `devised`, set to `various` if compilation. |
| `devised`<br />*(semi-optional)* | Used if play was devised | Either `true` for generic output or a descriptor. Example descriptor: `"Cast and Crew"` will output "Devised by Cast and Crew". Omit if using `playwright`. |
| `adaptor`<br />*(optional)* | Full name of adaptor | Outputs as "Adapted by adaptor". |
| `translator`<br />*(optional)* | Full name of the translator | Outputs as "Translated by translator". |
| `canonical`<br>Not yet implemented<br />*(optional)* | List of canonical titles and playwrights for reverse lookup. | Specify `title`s and/or `playwright`s in a list. See [#486](https://github.com/newtheatre/history-project/issues/486). |
| `student_written`<br />*(optional)* | Show written by a NNT member | Set to `true`, `false` or line missing are equivalent. |
| `company`<br />*(optional)* | If non-NNT the name of the company |  |
| `season` | Season show belongs to | Choices: Autumn, Spring, Edinburgh. |
| `season_sort` | Order which this show comes in the entire year | Use multiples of 10 for ease of additions.<br />Roughly: Autumn should start at 30, Spring 200 and Edinburgh 400. Shows then fall at 30, 40, 50 *e.t.c.* |
| `venue` | Venue show was performed in. |  |
| `venue_sort` | Group of venues `venue` belongs to. | Will group show together with other shows with the same `venue_sort`. For example C cubed, C nova, C soco, C too can all be grouped as C venues. |
| `date_start` | Date of first performance | In the format YYYY-MM-DD. |
| `date_end`<br />*(optional)* | Date of last performance | In the format YYYY-MM-DD, omit if show only ran one day. |
| `tour`<br>Not yet implemented<br />*(optional)* | List of *tours* the show has been on (NSDF *e.t.c.*). | Specify `venue`, `date_start`, `date_end` and `notes`. See [#12](https://github.com/newtheatre/history-project/issues/12). Shows taken to Edinbugh should have a separate show created under the `Edinburgh` period. |
| `cast` | Cast members | Uses the [person list](/docs/person_list) format. |
| `crew` | Crew members | Uses the [person list](/docs/person_list) format. |
| `prod_shots`<br />*(optional)* | SmugMug album ID for production shots | Use [util/smug-albums](/util/smug-albums/) to find the AlbumID. |
| `photos`<br />*(optional)* | Production shots **(depreciated)** | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `assets`<br />*(optional)* | Publicity and other materials | Uses the [photos and assets](/docs/photos_and_assets) format. |
| `published`<br>Not yet implemented<br />*(optional)* | *Not yet used!* | Will in the future hide the show if set to false. |
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

canonical:
- title: The Pillowman
  playwright: Martin McDonagh

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

prod_shots: abcd123

assets:
  - type: poster
    image: XJZCPfW
  - type: flyer
    image: XKsW92t
  - type: programme
    filename: the_pillowman_programme.pdf
    title: Programme

tour:
  - venue: The National
    date_start: 2013-01-01
    date_end: 2013-01-03
    notes: Show won award
---

In an unnamed police state, a writer has been arrested because the content of his stories bares a striking resemblance to a series of gruesome child murders. Interrogated by two brutal detectives, he claims to know nothing of such murders. But also in their custody is his younger, brain damaged brother, who perhaps knows more than he first lets on. A darkly comic thriller like no other.
{% endhighlight %}

