---
layout: docs
group: docs
title: Editing
order: 10
---

This page needs rewriting as an intro to editing actual files on the site, where stuff is &c.
{: .box-warning}

To edit the site you have several options. To make direct edits you must be added as a trusted editor to the [repository](http://github.com/newtheatre/history-project) by an [owner](https://github.com/orgs/newtheatre/people) however you can propose edits straight away for an editor to merge in.

You can either use the GitHub website or using a text editor on your computer. Either way you'll need a free GitHub account, you can [sign up here](https://github.com/join).

Ensure you have a verified email address with GitHub otherwise your changes will not trigger a build.

## Editing Online

### GitHub

<iframe class="youtube" src="https://www.youtube.com/embed/yC2aBvMgTzg?showinfo=0&color=white&modestbranding=1" frameborder="0" allowfullscreen></iframe>

To edit the site using the GitHub website click on the <strong class="tag"><i class="octicon octicon octicon-pencil"></i> Improve This Page</strong> button on the right hand edge of a page to launch the editor.

If you're not a trusted editor you'll be prompted to create a _fork_ and will be led through the process of creating a pull request. Later an editor will check your changes are valid and merge them into the repo.

## Editing Locally

<div class="box-info"><i class="fa fa-info-circle"></i>This method requires a certain amount of technical knowledge, but you can do different amounts with different levels of knowledge.</div>

This is the more complicated option, the benefits are you can use a desktop text editor and run the entire site on your machine to preview changes before they go live. You should have knowledge of Git and the command line to do this.

See [README.md](https://github.com/newtheatre/history-project/blob/master/README.md) for up to date install instructions.

Getting the site running on your machine locally is easy to do on Mac and Linux. It _can_ be done on Windows, but it's tricky. The website [Run Jekyll on Windows](http://jekyll-windows.juthilo.com/) has a full tutorial on how to do this.

## Syntaxes Used

A combination of HTML and Markdown (Kramdown variant) is used for marking up our pages. YAML is used for meta data and is documented for shows, committees etc here.

The [Kramdown syntax guide](http://kramdown.gettalong.org/syntax.html) is useful for reference.

## Where Things Live - Basic Editing

When first looking at the repository in a text editor, it can seem quite big, and finding where things live will take a bit of time, yet most of the content storage itself is self explanatory. For a basic contributor the main things you'll need to find are person files, show files and venue files. Individual person files live in the `_people/` folder from the main History Project repository. For info on how to format a person file, see the [People](https://history.newtheatre.org.uk/docs/person/) page. Files for individual shows live in the `_shows/` folder and are sorted by academic year, see the [Shows](https://history.newtheatre.org.uk/docs/show/) page. Venue files live in the `_venues/` folder, see the [Venues](https://history.newtheatre.org.uk/docs/venue/) page.

### Years

Years are one of the main attributes that are used within the project. These are important to get right and important for many different reasons. For more information on the correct formatting and usage, see the [Years](https://history.newtheatre.org.uk/docs/year/) page.

### Committees

New committees are usually added by a [Project Editor](https://github.com/orgs/newtheatre/people) at the start of each academic year. Committee files are stored in the `_committees/` folder. We do get submissions from alumni with information regarding past committees and these can be added by anyone. For detailed information on how to format a committee file, see the [Committees](https://history.newtheatre.org.uk/docs/committee/) page.

### Person Lists

These are used mainly to populate the cast and crew lists for shows. They are formatted in a particular way and this must be kept to otherwise other areas of the site could break or throw up errors as person lists are used to populate the person collection. For detailed information on formatting person lists, see the [Person List](https://history.newtheatre.org.uk/docs/person-list/) page.

### Link Lists

These are used particularly for reviews placed within show files, but the list of possible links is expanding as we grow the site, so could change in the future. For formatting details see the [Link List](https://history.newtheatre.org.uk/docs/link-list/) page.

### Trivia

One of the things we love collecting for the History Project are little bits of trivia or anecdotes regarding shows. Be this a last minute cast change for one night or something that happened that amused the cast, these stories are a vital part of what makes the NNT the NNT. To find out how to format these sections, visit the [Trivia List](https://history.newtheatre.org.uk/docs/trivia-list/) page.

### Photos and Assets

The History projects visual records are stored in a [SmugMug Site](https://photos.newtheatre.org.uk/). Anyone can view the production shots from any of our shows, but the other archives are stored in a way that if you have a link to the folder you can view its contents. Any show videos, such as Trailers or Behind the Scenes videos are also stored here. If you have any items you feel would be useful to the History Project, please see the [Sending In Images](https://history.newtheatre.org.uk/upload/)page.

Any binary assets, (pdfs etc.) are stored in a specific folder in the repo. These are stored using Large File Storage, or LFS. if you any of these type of assets, please email <{{site.email}}>.
