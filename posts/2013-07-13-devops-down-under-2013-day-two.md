---
layout: post
title: Devops Downunder 2013, Day Two
tags: devops, operations, conference
location: Sydney, New South Wales
excerpt: 
  These are my notes from the second day of Devops Downunder 2013 in Sydney,
  New South Wales.
---

I'm attending [Devops Downunder 2013][1] in Sydney, New South Wales. This is my
first devops event (and my first [open spaces][2] event) but I've heard good
things about both. I'll try to update this post over the course of the day. Not
real live blogging, more delayed telecast blogging.

[1]: http://devopsdownunder.org/
[2]: http://en.wikipedia.org/wiki/Open_Space_Technology

I'm typing these notes during the sessions, so there may be errors and
omissions. Any such problems are my fault and not that of the speakers.

# Lindsay Holmwood on Cognitive biases in devops

[Slides are available on Speaker Desk][bias]

[bias]: https://speakerdeck.com/auxesis/the-devops-field-guide-to-cognitive-biases

Confirmation bias: play devils advocate; us political bookmaking.

Negative views are often biased.

## Provisioning Automation

Resolving problems the provisioning teams were seeing with automation.

1. VMware is hurting us.

2. Then load balancing.

3. The VMware again.

4. Then EC2.

For 18 months.

## Hindsight bias

: incorrectly recalling (rewriting history). 

> petty good argument that Conservative media should go behind pay walls.

You could have avoided bad circumstances but didn't. Try harder.

Eg: devops ing the shit out of the alert that some you up last night (even of another one wakes you up twice add often).

Eg: higher conviction rates when prosecution sums up using hindsight language. Defence successful with foresight language.

## Dunning-Kruger effect

A little bit of knowledge is a dangerous thing. Judging skill in something (in self and others) requires skill.

Setting an impossible deadline: "it's just typing."

## Curse of knowledge

Making decisions hard or impossible due to overload of options, knowledge, etc.

Poor performers don't learn from feedback, because they think they know better.

I can X better than this.

Minimal training improves *self-assessment*, even in the absence of improved skill.

Non-technical management, lean on engineers.

East Asian societies seem to exhibit an inverted DK effect.

## better than average effect

People believe they have above average susceptibility to good attributes.

## Rhyme as reason

Aesthetics affect perception of truth. You are more likely to believe them.

## Fluency heuristic

How many fs? Skipping the ones in words like "of".

Induce randomness. Avoid s patterns the brain can fall into.

Checklist and formalise.

Make text styling simple. Simple fonts are more likely to answer a question correctly than in cursive font.

## normalcy bias

Ignore stuff which makes you uncomfortable about yourself. Organisation s have it bag.


## conclusion

> Twain: it ain't what you know...

See also:

- You are not so smart
- The field guide to understanding human error - Sidney Dekker

# Devops pay raise

> Quantify your value to move up the ladder.

Devops:

> Developers writing together with operations to get things done faster in an automated and repeatable way.

How do you know you're getting it right? Pager quiet?

> it worked fine in dev, ops problem now.

Nine nines is meaningless.

Grinding for a year on application support.

Business doesn't care about P1s, SLAs, etc. All they care about is money. They could never really prove that P1=£

Every one viewed him as a pain in the arse.

The 4am call about a *staging* server.

False alarms costing $70k per year. Mean time to innocence.

How many people have considered:

- How much have we saved the business?

- How much have qr cost the business?

## Missing

1. Automation

2. Collaboration

3. Visibility of the system

4. Business metrics. P1 is supposed to be business is impacted.

## should have done

1. Baseline starting position.

2. Measure progress.

3. Calculate impact on business. Allows you to 

4. promote success instead of problems.

5. Sell value

## Now

Monitoring and visibility tools.

Seeing utilisation, application performance monitoring.

Correlate business metrics.

## Automation

Time is money. Business people like money.

Infrastructure automation with puppet, chef, etc. How much time did these tools save?

Deployment automation. Jenkins, Capistrano, err yc.

Log automation. Log stash, spunk

Graphite, nagios, etc

## collaboration

What is the value of collaboration?

## value

Evaluate the cost of the tools and automation, etc. vs the savings. That's your value as a practitioner.

Tell type business how much devops culture has saved them.

# Sam Newman & Sebastian Cole on Puppet On Windows & Linux In The Cloud

Sebastian is from [Mi9][] and Sam is a consultant from ThoughtWorks. Mi9 is a
joint venture between Channel 9 and Microsoft. Run [ninemsn.com.au][] which
they've been trying to move to cloud-y sorts of things.

[Mi9]: http://mi9.com.au/
[ninemsn.com.au]: http://www.ninemsn.com.au/

Main site moved to AWS, trying to move everything else to the cloud too. Not
just AWS, also looking to Azure.

Using tools and techniques new to the business: Puppet, Linux (cost savings on
licensing). 250 instances, 70/30 Windows/Linux, equally divided between
Singapore and Sydney.

## Puppet vs Powershell

Windows administration tool of choice is Powershell. Have a lot of stuff already
written in Powershell, don't want to replace it.

Common pattern of Puppet `File` resource and `Exec` resource (with appropriate
`unless`, etc. attributes). Interface between Puppet and the script is blurry.

## Developing on Windows

- Rspec-puppet (but it wants symlinks)

Puppet Agent on Windows

Restarting Nagios client on Windows; Puppet Enterprise wasn't able to restart
services on Windows correctly, Puppet run turns the whole production
infrastructure red.

Package management is crappy on Windows (find, download, run an MSI) vs unix
(apt-get, yum, etc.); no consistent place to applications to store data and
configuration for Windows apps; there's rarely a single tool which can be used
across both platforms (percountermonitor vs collectd, curl vs .Net class)

Ease the pain with Nagios (agents for both platforms), Chocolatey (attempt at
package management for Windows), Graphite, Amanda (backups).

## Amazon Web Services

Initial move was a little wild-west; everyone had AWS keys, same account;
couldn't control access to specific resources (accidentally kill production
instead of staging).

IAM federation is good, but some services ("beta") like Beanstalk don't support
IAM federation.

Saw EC2 costs split between compute and network. Think about structuring
networking. Shutdown all the things that aren't tagged with "stay on all the
time".

Netflix Edda to inspect and record states of AWS resources. Hopefully be able to
record changes that happen, with or without failures in change control.

## Access control

- First uses Puppet to push SSH keys out.

- Goal to start using Active Directory (already using for OS-level auth). 

## Continuous Integration

Can be mismatch between using Puppet Master and continuous integration.

1. Code is committed.

2. Compile.

3. Tests pass.

4. It deploys!

5. Production.

Each of the stages may put the application into different environments -- dev,
test, staging, production. How does this work when the code is Puppet
configuration.

Using Puppet environments to dev, test, prod Puppet code. Need to use Puppet 2.5
with changes. Need to be able to manage Puppet as part of the environments.

Solution: the Puppet master for each environment is *part of* that environment.
Makes testing of changes to Puppet itself possible. No more breaking all the
things.

## Azure

Don't want to double team for another platform. Want to use existing tools --
Puppet -- in Azure too.

Automating Puppet master deployment means being able to run a Puppet master
within Azure.

Azure will be the 5th platform in use.

## Puppet and Windows

Windows loves Puppet, but Puppet (the development process) loves Windows quite
a bit less.

## Q&A

What are you using?

> Quite an array of platforms:
>
> - News site is .Net; purchased CMS.
> - NodeJS.
> - Ruby on Rails apps.
> - A few purchased Java apps.
> - Older sites are classic ASP.
> - Newer are .Net 2-4; rolling out 4.5
>
> Puppet focusses on newer side of things (Amazon, .Net 4)

Can Cygwin help with the cross platform issues?

> Started with this "paper over the differences" mentality but it just doesn't
> work. There are corner cases where Cygwin *isn't* like unix and you'll have
> to touch real Windows anyway.
>
> Also: it's essentially a Windows team.
>
> Also: The models aren't the same: registry, OO controls, etc. You can't just
> awk the registry. If you're trapped in Cygwin, you can't use apps that don't
> know the Cygwin filesystem stuff.
>
> Instead, use tools and processes which work on *both* platforms, rather than
> trying to pretend there's only one platform.
>
> Building higher-level tools which can support the different platforms, both
> OS and cloudish.

# Ignite Talks

## Zendesk guy (sorry for no name)

Trust

Processes: build processes that you -- and your team -- believe in; breaking
the processes breaks trust. Don't be the one who commits to master!

Being excellent isn't enough; all the people should improve all the things all
the time.

It's hard to regain trust that you've broken.

Be visible so that your team -- and other teams -- can see what you're doing.

## Tom Sulston: Failure - a love story ##

@tomsulston

Really like failure. Once destroyed all the telephones in Glasgow with a single
perl script.

Also likes schadenfrued: Zune, Vanilla Coke, Nokia nGage, Google Wave, betamax.
All seemed like good ideas at the time.

- Design
- Marketing and pricing
- Don't know what you're doing

These were all large failures. They didn't fail soon enough; failing before
your ship leaves port is a really good idea.

We have tools like Jenkins and continuous integration to fail early, before it
goes like.

Fail fast, learn the lessons and don't have massive projects blow up. Failing
leads to deep, strong learnings; break cognitive biases. Failure is always an
option.

Failcake: when you fail and something breaks, you have to buy the team cake. It
makes the failure OK; it's hard to be angry with a mouthful of cake.

Also: ThoughWorks Australia is hiring, go talk to one of them if you're
interested.

## Rene(sp?) from NAB

"Devops Doesn't Work" but a few years later it's in CIO Magazine, Gartner are
looking into it, etc. Is this jumping the shark?

Job trends for technologies in, e.g., Puppet. Big enterprises which are trying
to "buy" devops.

Devops as succeeding together

# Open Spaces

## Sharing and Reuse with Puppet

20 infastructures running different apps, etc. Standardisation and
centralisation, but engineering teams won't want to be able to see *their*
environment and be able to *change* their environment. Keeping standardisation
but allowing specialisation, versioning for specific configurations.

Possible:

- Use heira and allow them to see their heira values. Would need to update to
  Puppet 3.0 to make that useful.

- Possibly publish versions and such as facts in /etc/fact.d/ and expose the
  facts to them.

- Is Puppet doing too much? Where's the demarkation between system configuration
  and application configuration? Perhaps the version information, etc. belongs
  in the application repo rather than the Puppet configuration.

Diverse requirements: rubies (MRI 1.9.1, 1.9.2, 1.9.3, jRuby, etc.), databases
(MySQL, PostgreSQL). All on Ubuntu and AWS.

- A YAML file per environment (i.e. project) containing overrides with versions
  and the like.

- Package the application and use the native package manager to handle the
  dependency and version requirements.

- Perhaps: pre-baked AMI; cloud init script to `apt-get` install the package;
  configure details like DB credentials in Puppet, etc. Again: may be getting
  Puppet to do too much.

- The whole thing of reusable Puppet modules which are all things to all people
  is just rubbish.

- Another suggestion (from Rio Tinto) of using Hiera with "project" layer for
  version pinning, etc. (Lots of modules are pre-Hiera.) Put logic into the
  Hiera tree to avoid conditionals in the manifests: common, $sdlc_env (capture
  test, stage, etc.), $site (DC, etc.)

- Take existing Puppet 3.0 stack and adapt it for Windows. Doing it by
  overriding a bunch of stuff in Hiera based on `$os_family`.

- To branch or not to branch Puppet modules and such.

    > I don't always test but when I do, I do it live.

    Avoid branching if we can -- no divergence, etc. Some good workflows around,
    e.g. using the git sha as the environment name.

    Maybe use a normal git workflow of dev, stage, prod branches.

    Dude from Puppet Labs published a ruby script for synching branches into
    environments on the Puppet master.

    Using buildbot with quiescent VMs to deploy pushed Puppet code and do
    functional testing. Want to add a noop run against changes and catch errors
    quicker than deploying to test machines.


