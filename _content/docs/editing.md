---
layout: docs
group: docs
title: Editors' Guide
order: 10
---

This guide will take you through the types of code that are used throughout the site, where it's all stored, and our approximate coding style we use.

Information about getting started and _how_ to edit can be found in our [Contributors' Guide](https://history.newtheatre.org.uk/docs/contributing). 


## <i class="octicon octicon-gist"></i> Languages and Syntaxes Used

We use different languages and syntaxes for different areas of the site and indeed within files.

### Content Pages - Markdown and YAML

Metadata for all content pages is written in YAML, and starts the file. The metadata exists between two `---` lines, like so:
{% highlight markdown %}
---
title: Editors' Guide 
--- 
{% endhighlight %}

The Kramdown flavour of Markdown is used for the content of all pages, from shows and people, to about pages and documentation. The [Kramdown syntax guide](http://kramdown.gettalong.org/syntax.html) is useful for the technical side of things, while our [Style Guide](#-style-guide) below is helpful for formatting. 

**Tip:** YAML doesn't like tabs at all, or colons in strings. If you're indenting, use spaces, not tabs. If you've got a string (such as a URL or show title) with a colon in it, wrap it in quotes (`""` or `''`) and all will be well. 
More YAML tips can be found [on GitHub](https://github.com/datatxt/awseome-yaml/blob/master/README.md).

### Template Pages - HTML and Liquid; CSS and Javascript

The History Site is a static site powered by [Jekyll](https://jekyllrb.com). It uses HTML to structure its pages, made more powerful with Jekyll's Liquid templating language. The templates use the metadata (known as _frontmatter_) to lay the page out in the correct way and put the data in the right places. 

You can learn more about how Jekyll's templates work by reading [their documentation](https://jekyllrb.com/docs/templates/)

Our CSS files are compiled using Sass to create a consistent look across all of our pages, and we have a number of Javascript functions running throughout. 

### Advanced Functionality - Ruby

Marrying up a vast amount of data with static templates is no mean feat, and sometimes this data needs to be manipulated first. We do that with Ruby. 

We've also got some Ruby plugins written for Jekyll on the site which allow us to, for instance, see people's commitee positions on their profiles.

## <i class="octicon octicon-file-submodule"></i> Where Things Live 

When first looking at the repository in a text editor, it can seem quite big, and finding where things live will take a bit of time, yet most of the content storage itself is self-explanatory. 

The most commonly edited content files are person, show and venue files. 

|---
| File | Lives in | Documentation Link
| - | - | -
| Show | `_shows/` | [Shows](https://history.newtheatre.org.uk/docs/show/)
| Committee | `_committees/` | [Committees](https://history.newtheatre.org.uk/docs/committee/)
| Person | `_people/` | [People](https://history.newtheatre.org.uk/docs/person/)
| Venue |`_venues/` | [Venues](https://history.newtheatre.org.uk/docs/venue/)
| - | - | -
| Standalone Pages | `_content/` | [Above](#content-pages---markdown-and-yaml) 
| Liquid Template | `_includes/`, `_layouts/` | [External - Jekyll](https://jekyllrb.com/docs/templates/)
| Sass and CSS | `_sass/` | [External - Sass-Lang](https://sass-lang.com/)
| Ruby Plugins | `_plugins/` | [External - Jekyll](https://jekyllrb.com/docs/plugins/)

For each of the below areas, click on the <i class="octicon octicon-book"></i> icon to go to the relevant page of the documentation.

### Years [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/year/)

Years are one of the main attributes that are used within the project. These are important to get right and important for many different reasons. 

### Committees [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/committee/)

New committees are usually added by a [Project Editor](https://github.com/orgs/newtheatre/people) at the start of each academic year. Committee files are stored in the `_committees/` folder. We do get submissions from alumni with information regarding past committees and these can be added by anyone. 

### People [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/person-list/)

You can't make a show without some people, but the History Project will generate people pages whenever they're in a list (below). However, dedicated pages can be created to specify things like course, career, photo, or a biography. 

### Person Lists [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/person-list/)

These are used mainly to populate the cast and crew lists for shows. Check out the documentation for the formatting of lists, which is very important. For people without dedicated profiles, these lists allow for automatic generation of profiles. 

### Venues [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/venue/)

As well as the New Theatre, we've taken shows all over the country, most frequently to the Edinburgh Festival Fringe. Each venue has its own page where the shows at that venue are listed. We want to know all about these venues, so information can be added in these content pages. 

### Link Lists [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/link-list/)

These are used particularly for reviews placed within show files, but are also used for external links for both people and venues. The list of possible links is expanding as we grow the site, so could change in the future. 

### Trivia [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/trivia-list/)

One of the things we love collecting for the History Project are little bits of trivia or anecdotes regarding shows. Be this a last minute cast change for one night or something that happened that amused the cast, these stories are a vital part of what makes the NNT the NNT. 

### Photos and Assets [<i class="octicon octicon-book"></i>](https://history.newtheatre.org.uk/docs/photos-and-assets/)

The History Project's visual records are stored in a [SmugMug Site](https://photos.newtheatre.org.uk/). This ranges from production shots and trailers, to backstage videos and lighting plans. Production shot galleries are public, but other archives, such as our album of headshots, are restricted such that only those with the link may view them in full (though individual photos crop up across the site). 

We're always looking for more media, no matter the size. Whether it's photos and videos, or posters and programmes, we'll have it all. Check out [how to upload](https://history.newtheatre.org.uk/upload/). 

Any binary assets, (pdfs etc.) are stored in a specific folder in the repository. These are stored using Large File Storage, or LFS. if you have any of these type of assets that you think may be useful to the project, please email <{{site.email}}>.

## <i class="octicon octicon-checklist"></i> Style Guide 

With many editors on our team, there are many tastes on how certain things should be displayed. To avoid [bikeshedding](https://en.wiktionary.org/wiki/bikeshedding), we've documented our preferences. This quick guide only covers content formatting - for code, we strive to cover the best practices of readability and commenting where necessary.

### Referencing Titles 

Given not all of the content areas of the site are displayed with Markdown, references to any title (show, TV programme, film, etc.) should be in single quotes (`'The Tempest' by William Shakespeare`) and not italicised. 

### Quotes 

Quotes should attempt to be as accurate as possible to the source, but understandably with short quotes context can be missed. If you're omitting part of a quote, insert `[...]` to indicate so. Cases at the start and end of quotes can be changed without indication (i.e., no need for `[T]he`).

If you need to clarify a quote, for instance a name, just add or edit using square brackets. For example, `it was brilliant` could become `['The Tempest'] was brilliant`.

### People Lists 

There are a few formatting things we do to make sure all of our people lists are consistent. 

#### Role-first 

When listing people, list their role first and then their name.

#### Multi-roles 

In many shows, an actor will take on multiple roles. We display these by separating each role with a forward slash, flanked by spaces:

{% highlight markdown %}
- role: Macbeth / Macduff / Doctor 
  name: John Smith 
{% endhighlight %}

For crew, someone taking on multiple roles are listed as separate entries.
 
{% highlight markdown %}
- role: Producer
  name: Jane Doe 
- role: Technical Director 
  name: Jane Doe 
{% endhighlight %}

For the avoidance of doubt, musicians are considered as crew, and should be credited with musician as their role, and the instrument(s) as a note:

{% highlight markdown %}
- role: Musician
  note: Sax / Clarinet
  name: Joe Bloggs
{% endhighlight %}

This same concept can be used in other crew roles as appropriate.

#### Ordering of Names

When adding cast to a show file, best practice is to put them in the order they are found in the relevant show's Programme.

When adding crew to a show file, there is a standard order in which roles are listed. This can be found in the [skeleton show file](https://github.com/newtheatre/history-project/blob/master/_shows/_skeleton.md).
