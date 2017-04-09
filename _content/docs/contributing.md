---
layout: docs
group: docs
title: Contributors' Guide
order: 5
permalink: /docs/contributing/
---

Hey! Interested in helping out with the project? We'd love your help.

Both the project's content and code to power it are stored in a _GitHub [repository][gh-repo]_. As such there are two types of work going on in parallel: editorial and technical. You can help out with either, or both! We plan and track work that needs doing in the [_issue tracker_][gh-issues] of our repository.


## Ways to contribute

- Talk to alumni and [collect information and media](#-collecting-information).
- Comment on some of the [project's issues](#-issues).
- Read through current content, and click "improve this page" to [correct or add information](#-making-improvements).
- Find an [open issue](#-issues) and submit a [proposed fix](#-making-improvements).
- Help evaluate open pull requests, by reading through and testing what's proposed.


## <i class="octicon octicon-issue-closed"></i> Issues

![Listing of issues](/images/docs/gh-issues.png)

We use numbered _issues_ to track both technical and editorial work that needs doing. The listing of [open issues][gh-issues] is public and can be found in our GitHub repository. Each issue can be a quick to-do list item, which is quickly ticked off, or a hub for discussion over a complex task.

The best way to get started is to read over what's currently open and start commenting on issues that interest you.

### <i class="octicon octicon-issue-opened"></i> Creating a new issue

Spotted an error on the site, have some information to share, or want to start a discussion on a particular topic? You need to [create an issue][gh-issues-new]. Be as descriptive as possible, for example if the issue involves a problem with the site try and include screenshots. Other contributors can then comment and someone can take a crack at fixing the problem.


## <i class="octicon octicon-repo-push"></i> Making improvements

[Git][git-scm] is a _version control system_, we use it to keep track of changes to the project's files. This is a similar system to that used to track the history of articles on Wikipedia.

### <i class="octicon octicon-repo-forked"></i> Branching and making changes

The process of getting a change committed and a pull request opened may seem daunting at first, but stick with it. Once you've done it the first time it's not too bad, honest!

#### Forking and branching

Firstly you'll need to create your own _fork_ of the respository on which to work. Head over to the [repository][gh-repo] and hit the _<i class="octicon octicon-repo-forked"></i> Fork_ button up top-right. You'll need to create a free GitHub account if you don't have one already.

#### Using the web interface (github.com)

1. Find the file you want to edit. Shows are stored in the `_shows` folder, people in `_people` _e.t.c._ See the [editing documentation](/docs/editing/) for more information on actually making your edit. The _Find file_ button is quite useful for this.
2. Click the <i class="octicon octicon-pencil"></i> pencil in the top right to start an edit.

#### Making edits locally on your computer

This method requires a certain amount of technical knowledge but is a lot more flexible.
{: .box-info}

1. Fork the project by clicking "Fork" in the top right corner of [newtheatre/history-project](https://github.com/newtheatre/history-project).
2. Clone the repository locally `git clone https://github.com/<your-username>/history-project`.
3. Create a new, descriptively named branch to contain your change `git checkout -b my-awesome-change`.
4. Using your preferred editor, make your changes.

#### Writing a good commit message

Using git we can see _what_ changed in a particular commit, only a good commit message can tell us _why_. This is very important for the future when other editors will be updating your work. In the case of show data, they'll need to know your sources and how credible information you've gathered is.

When writing commits, try and adhere to the following rules:

1. Limit the subject line to **about 50 characters**.
2. **Capitalize** the subject line and do not end it with a period.
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

#### Submitting a pull request via the web interface (github.com)

5. When commiting your changes select "<i class="octicon octicon-git-pull-request"></i> Create a new branch for this commit and start a pull request". Enter a short descriptive branch name.
6. Click "Propose file change"
7. Give your PR a descriptive title and description.
8. Click "Create pull request"

That's it! You'll be automatically subscribed to receive updates as others review your proposed change and provide feedback.

#### Submitting a pull request via Git command line

5. Push the branch up (`git push origin my-awesome-change`).
6. Create a pull request by visiting `https://github.com/<your-username>/history-project` and following the instructions at the top of the screen.


## <i class="fa fa-envelope"></i> Collecting Information

We've only collected a subset of all the shows the New Theatre has put on over the years. We need people to reach out to the alumni community and gather both memories of past shows and events and physical media from the time.

If you fancy helping out let one of the editors know, send us an email at <history@newtheatre.org.uk>.


## Anything else

See the other pages here for more detailed information about each section of the site.

If you get stuck, or want to help out another way, send us an email at <history@newtheatre.org.uk> or get in touch with any of the [editors](https://github.com/orgs/newtheatre/people).


[gh-repo]: https://github.com/newtheatre/history-project
[gh-issues]: https://github.com/newtheatre/history-project/issues
[gh-issues-new]: https://github.com/newtheatre/history-project/issues/new
[gh-pulls]: https://github.com/newtheatre/history-project/pulls

[git-scm]: https://git-scm.com/

[chris-beams-commits]: https://chris.beams.io/posts/git-commit/
[gh-help-auto-close]: https://help.github.com/articles/closing-issues-via-commit-messages/
