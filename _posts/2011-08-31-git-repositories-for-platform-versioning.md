---
layout      : post
title       : Using git repositories for platform versioning
categories  : [git]
tags        : [git, drupal, workflow, platforms, distribution]
location    : Perth, Western Australia
excerpt     : |
  This is a guide to my current thoughts on using git to maintain and
  distribute platform releases for Drupal-based projects.
---

I'm not sure how widely this might be applicable but I've found it an
interesting problem to think about and it's going to help iron out some
wrinkles in our workflow.

We have a standard platform that does a great deal of the scutwork required of
a generic CMS based on Drupal. What's included in it doesn't really matter
(it's an install profile that does a bunch of stuff), just that it's the base
of many of our projects and it is maintained as a unit and upgraded as a whole
on individual sites.

I currently maintain this using a bunch of git repos, a custom feature server
(which uses `ssh` tunnels to access the git repos), `drush make` and about a
dozen other moving parts which produce a new build of the platform in a
tarball. Needless to say this is tedious, error prone, and means new releases
are slower than they should be. Git to the rescue!

Rather than building tarballs of platform releases manually I'll be
maintaining canonical versions in repositories and using git to manage
applying upgrades to individual projects.

Creating a platform
-------------------

This first step is creating my "blessed" platform repository. To keep things
simple I'll describe managing two platforms:

- `6.x` is the current release of Drupal 6; and

- `7.x` is the current release of Drupal 7.

As this repo is somewhat special I'm going to take some pains to make sure
it's structured exactly as I want it. In particular, I want every branch to be
correspond to one of my platforms. This is a little tricky but it only happens
once so don't worry too much if you find it confusing.

    # Initialise a new empty repo and add the origin I'll push the result to
    mkdir platform
    git init
    git remote add origin git@gorilla:/platforms/drupal.git

    # First, let's create the Drupal 6 branch.
    git symbolic-ref HEAD refs/heads/6.x
    rm .git/index
    git clean -fdx
    drush dl --yes --drupal-project-rename=htdocs drupal-6
    git add htdocs
    git commit -m 'drupal-6'
    git push origin 6.x

    # Now, let's take care of the Drupal 7 branch.
    git symbolic-ref HEAD refs/heads/7.x
    rm .git/index
    git clean -fdx
    drush dl --yes --drupal-project-rename=htdocs drupal-7
    git add htdocs
    git commit -m 'drupal-7'
    git push origin 7.x

This sequence is a little verbose (the `rm` and `git clean` for Drupal 6
aren't strictly necessary) but it should be obvious how I can add additional
platforms.

Assuming that the repo at `git@gorilla:/platforms/drupal.git` was newly
`init`ed, it should now contain a `6.x` branch containing Drupal 6 and a `7.x`
branch containing Drupal 7.

For safety's sake, it'd probably be a good idea to have push restrictions on
the platform repository to prevent accidental and illicit modifications
flowing back from projects into platforms. It's outside the scope of this
document to describe how to do this but you probably want to use `gitolite` or
something else with fine-grained access control (i.e. not gitosis).

Starting a project
------------------

Now that my platforms are available in git I can use them as the starting
point for a new project. I just clone the right branch from the platform repo
and I'm off!

    git clone --origin platform --branch 6.x git@gorilla:/platforms/drupal example.com
    cd example.com
    git checkout -b master

It's a bit confusing at first glance, so I'll break that down a bit. First I
clone the platform repository with the `git clone` command. Instead of letting
it use default values I'm telling it what to call the *origin* remote in the
new repository (`platform` instead of `origin`) and which branch to clone
(`6.x` instead of the default `HEAD` in the remote). Running this command will
create a new repository in `example.com/` with a remote called `platform` and
a single branch called `6.x` (based on the `6.x` in `platform`).

I recommend using the `6.x` branch exclusively for pulling in new releases of
the platform so I also create a `master` branch to work on with the next git
command does.

Now `example.com` has two branches: `6.x` where I can pull in new releases of
the platform, and `master` where I'll be working on the *example.com* site.

Upgrading a project
-------------------

Upgrading a project to run on the latest version of it's platform should be a
simple matter of pulling the appropriate branch and merging the changes into
`master`.

    cd example.com
    git checkout 6.x
    git pull
    git checkout master
    git merge 6.x

Here I checkout the "platform" branch (`6.x` as in the example above) and pull
in any remote changes. Then I checkout the `master` branch and merge the
changes in the updated `6.x` branch.

Unless I've been a naughty boy and modified files that are "owned" by the
platform this shouldn't result in so much as a merge conflict.

Conclusion
----------

I haven't rolled this new method out at work yet but it's in the pipeline. I'm
quite excited by it and I think it'll help make what's currently tedious and
error prone into something of a NOOP. Hopefully the rest of the team agrees!

Have you done something similar? Have I missed some serious consideration? Is
this all old hat and I should get with the programme? I'd love to hear any
comments or feedback on the approach I've described.
