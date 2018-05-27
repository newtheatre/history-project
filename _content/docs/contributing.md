---
layout: docs
group: docs
title: Contributors' Guide
order: 5
permalink: /docs/contributing/
---

Hey! Interested in helping out with the project? We'd love your help.

Both the project's content and code to power it are stored in a _GitHub [repository][gh-repo]_. As such there are two types of work going on in parallel: editorial and technical. You can help out with either, or both! We plan and track work that needs doing in the [_issue tracker_][gh-issues] of our repository.

If you're new to Git and GitHub, there are a [wealth of resources][gh-resources] on their website to get used to the basic technical concepts involved. Don't worry if you've never touched a line of code before - you can still contribute!

## Ways to contribute

- Talk to alumni and [collect information and media](#-collecting-information).
- Comment on some of the [project's issues](#-issues), clarifying queries or adding to the discussion.
- Read through current site content, and click "improve this page" to [correct or add information](#-making-improvements).
- Find an [open issue](#-issues) and submit a [proposed fix](#-making-improvements).
- Help evaluate [open pull requests][gh-pulls], by reading through and [testing what's proposed](#-testing-pull-requests).

## <i class="fa fa-envelope"></i> Collecting Information

We've only collected a subset of all the shows the New Theatre has put on over the years. We need people to reach out to the alumni community and gather both memories of past shows and events and physical media from the time.

If you fancy helping out, let one of the editors know by sending us an email at <history@newtheatre.org.uk>.

## <i class="octicon octicon-issue-closed"></i> Issues

![Listing of issues](/images/docs/gh-issues.png)

We use numbered _issues_ to track both technical and editorial work that needs doing. The listing of [open issues][gh-issues] is public and can be found in our GitHub repository. Each issue can be a quick to-do list item, which is quickly ticked off, or a hub for discussion over a complex task.

The best way to get started is to read over what's currently open and start commenting on issues that interest you.

### <i class="octicon octicon-issue-opened"></i> Creating a new issue

Spotted an error on the site, have some information to share, or want to start a discussion on a particular topic? You need to [create an issue][gh-issues-new]. Be as descriptive as possible. For example, if the issue involves a problem with the site try and include screenshots or instructions on how to reproduce it. Other contributors can then comment and someone can take a crack at fixing the problem.

## <i class="octicon octicon-repo-push"></i> Making improvements

[Git][git-scm] is a _version control system_, we use it to keep track of changes to the project's files. This is a similar system to that used to track the history of articles on Wikipedia. Every change made to every file on the site is logged in a _commit_, and when you've made one or more changes (commits), it can then be merged into the site with a _pull request_.

### <i class="octicon octicon-repo-forked"></i> Branching and making changes

The process of getting a change committed and a pull request opened may seem daunting at first, but stick with it. Once you've done it the first time it's not too bad -- honest!

#### Forking and branching

Firstly you'll need to create your own _fork_ of the respository on which to work. This is your own version so you can make your changes without worrying about affecting the main site. 

Head over to the [repository][gh-repo] and hit the _<i class="octicon octicon-repo-forked"></i> Fork_ button at the top-right. You'll need to [create a free GitHub account](https://github.com/join/) if you don't have one already. Now you're ready to start editing!

#### Using the web interface (github.com)

<iframe class="youtube" src="https://www.youtube.com/embed/yC2aBvMgTzg?showinfo=0&color=white&modestbranding=1" frameborder="0" allowfullscreen></iframe>

1. Find the file you want to edit. Shows are stored in the `_shows` folder, people in `_people`, _etc._ See the [Editors' Guide](/docs/editing/) for more information on actually making your edit and how the files are arranged. The _Find file_ button is quite useful for this.
2. Click the <i class="octicon octicon-pencil"></i> pencil in the top right to start an edit.

#### Making edits locally on your computer (command line)

This method requires a certain amount of technical knowledge but is a lot more flexible. It uses Git on the command line, and there are additional guides for [getting started](https://git-scm.com/doc) there.
{: .box-info}

1. Fork the project by clicking "Fork" in the top right corner of [newtheatre/history-project](https://github.com/newtheatre/history-project).
2. Clone the repository locally `git clone https://github.com/<your-username>/history-project`.
3. Create a new, descriptively named branch to contain your change `git checkout -b my-awesome-change`.
4. Using your preferred text editor, make your changes. See the Editors' Guide for more detailed information on this and the text editors we use.

#### Making edits locally on your computer (graphical methods)

The command line isn't for everyone, and that's why other bits of software exist. We've tried [Gitkraken](http://gitkraken.com) and [GitHub Desktop](https://desktop.github.com/), and the Git website has a [full list of options][git-guis].

The concept is exactly the same as above: clone, branch and commit. 

#### Building the site locally 

By editing on your computer, you can run the entire site and preview changes before pushing them to GitHub. You should have a good knowledge of Git and the command line before doing this.

See [README.md](https://github.com/newtheatre/history-project/blob/master/README.md) for up to date install instructions.

Getting the site running on your machine locally is easy to do on Mac and Linux. It _can_ be done on Windows, but it's tricky. The website [Run Jekyll on Windows](http://jekyll-windows.juthilo.com/) has a full tutorial on how to do this.

#### Writing a good commit message

Using git we can see _what_ changed in a particular commit, but a good commit message can tell us _why_. This is very important for the future when other editors will be updating your work. In the case of show data, they'll need to know your sources and how credible the information you've gathered is.

When writing commits, try and adhere to the following rules:

1. Limit the subject line to **about 50 characters**.
2. **Capitalise** the subject line and do not end it with a full stop.
3. Use the **imperative tense** in the subject line.
4. **Use the body to explain** what and why.

Your subject line should tell us what you've done.

{% highlight markdown %}
Add crew members to Hamlet (82)
{% endhighlight %}

Note we've used the imperative `Add crew`, not the indicative `Added crew`. To remove any confusion, here’s a simple rule to get it right every time. A good subject line should always be able to complete this sentence: `If applied, this commit will <your subject line here>`.

The body, or description should tell us why you've done it:

{% highlight markdown %}
Got information from alumnus Fred Bloggs (BA Archaeology 1984). Spoke on the phone.

Will close #123
{% endhighlight %}

Note we've specified the years of both the show and the alumnus. This prevents confusion between items with the same name. Also note the referencing of an issue number, doing so in this manner [will automatically close the issue][gh-help-auto-close] when the commit is merged into master.

When adding new or changing current information include a source, even if it is yourself.

For further reading on this topic please see this excellent article: [How to Write a Git Commit Message][chris-beams-commits].

### <i class="octicon octicon-git-pull-request"></i> Submitting a pull request

Now you've made one or more commits it's time to open a _pull request_ to request a project maintainer to _pull in_ your work to the main repository.

Do bear in mind the smaller the proposed change, the better. If you'd like to propose two unrelated changes, create two branches and submit two pull requests.

All pull requests get built to a testing environment, and go through some automated code checks. Ensure you have a verified email address with GitHub otherwise your changes will not trigger a build.

Just like commits, it's possible to add a subject and message for your pull request. It's useful here to explain what you've still got to work on in the message. For example, you could make a pull request for a work in progress (denoted by `WIP` in the subject) so that others know you're working on it, but that it's not ready for merging.

As other editors of the site will be reviewing your pull request, include in the message what you'd like to draw to their attention such as specific feedback or any help you need.

For further reading on pull requests do read Ben Balter's article: [The six types of pull requests][ben-balter-pulls]

#### Submitting a pull request via the web interface (github.com)

5. When commiting your changes select "<i class="octicon octicon-git-pull-request"></i> Create a new branch for this commit and start a pull request". Enter a short descriptive branch name.
6. Click "Propose file change"
7. Give your PR a descriptive title and description.
8. Click "Create pull request"

That's it! You'll be automatically subscribed to receive updates as others review your proposed change and provide feedback.

Using one of the other software-based options have a very similar process to the one above.

#### Submitting a pull request via Git command line

5. Push the branch up (`git push origin my-awesome-change`).
6. Create a pull request by visiting `https://github.com/<your-username>/history-project` and following the instructions at the top of the screen.

### <i class="octicon octicon-beaker"></i> Testing Pull Requests

There are a number of ways to review an editor's pull request, and this can depend on what they're looking to get out of the review. The basics involve the automated checks, as well as adherence to our style guide, comments, efficiency, and so on.

You can also make sure the code runs effectively by running it on your own computer by building it, or viewing the edited pages in the test environment. A link to this test environment will be on the pull request page, once it's built successfully.

### <i class="octicon octicon-verified"></i> Becoming a Contributor 

If you decide making these kinds of edits and contributions is for you, we'd love to have you as part of [the team](https://github.com/orgs/newtheatre/people)! We're all volunteers here, and once you've had a few pull requests merged you'll be able to join the list of contributors. This means you won't have to make your own forks, and can edit the finer details of issues and pull requests.

## <i class="octicon octicon-question"></i> Anything else

See the other pages here for more detailed information about each section of the site.

If you get stuck, or want to help out another way, send us an email at <history@newtheatre.org.uk> or get in touch with any of the [editors](https://github.com/orgs/newtheatre/people).


[gh-repo]: https://github.com/newtheatre/history-project
[gh-issues]: https://github.com/newtheatre/history-project/issues
[gh-issues-new]: https://github.com/newtheatre/history-project/issues/new
[gh-pulls]: https://github.com/newtheatre/history-project/pulls

[git-scm]: https://git-scm.com/

[chris-beams-commits]: https://chris.beams.io/posts/git-commit/
[gh-help-auto-close]: https://help.github.com/articles/closing-issues-via-commit-messages/
[gh-resources]: https://help.github.com/articles/git-and-github-learning-resources/
[git-guis]: https://git-scm.com/downloads/guis
[ben-balter-pulls]: https://ben.balter.com/2015/12/08/types-of-pull-requests/
