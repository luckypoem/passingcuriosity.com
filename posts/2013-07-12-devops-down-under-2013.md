---
layout: post
title: Devops Downunder 2013, Day One
tags: devops, operations, conference
location: Sydney, New South Wales
excerpt: 
  These are my notes from day one of Devops Downunder 2013 in Sydney, New South
  Wales.
---

I'm attending [Devops Downunder 2013][1] in Sydney, New South Wales. This is my
first devops event (and my first [open spaces][2] event) but I've heard good
things about both. I'll try to update this post over the course of the day. Not
real live blogging, more delayed telecast blogging.

[1]: http://devopsdownunder.org/
[2]: http://en.wikipedia.org/wiki/Open_Space_Technology

I'm typing these notes during the sessions, so there may be errors and
omissions. Any such problems are my fault and not that of the speakers.

# Introduction

Thanks to the gold sponsors: anchor, puppetlabs, realestate.com.au

Open Spaces is all unconferency. Un-organised or dis-organised, it's our call.

There's a function this evening with a bar tab, etc.

# Andrew Clay Shafer on There is no talent shortage

My notes from this talk are pretty sloppy. Sorry.

> According to the [programme][3] [this talk][4] is the first devops days event
> which started ahead of schedule.

[3]: http://www.devopsdays.org/events/2013-downunder/program/
[4]: http://www.devopsdays.org/events/2013-downunder/proposals/There_is_no_talent_shortage/

The talent shortage, if there is one, is unevenly distributed.

Puppet (and similar tools) were attempts to build a competitive advantage:
organisations without it would be faced with a critical disadvantage. 2008
presentation slides include pictures of the Gatling gun.

Andrew joined the Puppet project as a developer; never worked in and wasn't
passionate about operations, and *worked* as a software developer (also not a
passion).

Fascinated with the dynamics of high performance organisations and the
individuals that comprise them. You often see sports teams of exceptional
individuals who can't play well together.

Reference to karate master being beaten at UFC-2. Mentally and physically
unprepared for "combat".

GM dominated the US car and truck market in the 1960s. Their executives visited
Japan when their auto industry (with lean, just-in-time, etc.) was nascent and
came away convinced that it wasn't true because of the lack of inventory,
stockpiles, etc.

Tools like CFEngine, Puppet, Chef, Jenkings, TravisCI, Vagrant, AWS, Docker.
Books like Release It!, Continuous Delivery, Web Operations, Phoenix Project,
Dev and Ops. The game has changed.

Devops is many things to many people. Elephants and blind men. Molesting the
elephant in the room.

Working with organisations, etc. who ask "what should we do?" respond "we can't
do that." And "who should we hire?" These people wind up thinking devops doesn't
work and we can't hire the right people.

## Patterns for success

People often say "devops doesn't work" or "agile doesn't work" missing the fact
that work is done by *people*, not abstract practices.

> [Maverick][maverick]. Book about a guy who ran a company doing everything
> backwards.

[maverick]: http://www.amazon.com/dp/0446670553/

Anecdote about is/has eaten the world.

Netflix.

> The *real* comapny values are shown by who gets rewarded and promoted and who
> is let go.

You are either building a software business or you're loosing to someone who is.

Either you're building a learning organisation or you're loosing to one that is.
We need to incentivise learning within our organisations:

7 dimensions:

1. Continuous learning - create continuous learning opportunities.

2. Inquiry and feedback

3. Team learning - collaboration

4. Empowerment - avoid C&C hierarchies

5. Embedded systems - capture and share learning within teams and communities.
   Jargon, etc.

6. System connection - active effort to connect systems, within and without.

7. Strategic leadership

See the Dimensions of Organisational Learning Questionnaire.

Stop conflating "learning" with "training". If you don't experiment before you
build the system, then the system is an experiment.

Learning happens *within* the process. Continuous integration & deployment work
by providing feedback and learning within the process. Do the same thing with
learning: continuous learning.

## Q&A

> People intrinsically *want* to learn, be challenged, etc. Introducing some of
> these practices will result in people picking up or leaving (pushed too far
> out of their comfort zone).

# David Lutz on Devops, Dungeons & Dragons

http://www.devopsdays.org/events/2013-downunder/proposals/Devops%20Dungeons%20and%20Dragons/

> Hi. My name is David and I'm a sysadmin. I've been on call (rosters) for 10
> years.

## Beginner vs expert

Scenario One: Johnny's first week in his first sysadmin job. When the phone
rings at 3am, the web site is running slow so he reboots the servers. Causing a
complete outage. Seeing a highload on the DB he reboots the DB server. He's
doing everything wrong; it's a train wreck. "The site was a cluster fuck but
it's coming back up now."

Scenario Two: John is an experienced sysadmin. The first thing John does is to
communicate with the rest of the team: "I'm on it." Then he looks at the change
log (the developers probably broke something). He looks at some graphs;
methodically gets a view of the state of system: 7s page loads instead of 5s.
Look at the DB and see lots of connections from some servers, notice it's caused
by an external outage; disable that bit, log tickets with external and developer
team to fix issues.

Johnny hasn't fixed the problem so he'll get worken up again in an hour.

Jo'burg has the highest rate of gun violence in the world. Their hospital is
world renowned, interns come to learn from all over the world.

## How to level up?

We need to practice.

Four stages to learning a new skill:

1. Unconcious incompetance - I don't know what I don't know. 6 days

2. Concious incompetance - I know what I don't know. 6 weeks

3. Concious competance - I know it, but it's hard. 6 months

4. Unconcious competance - I know it, and don't have to think about it. 6 years

The purpose of training and practice is to reduce the time between the four
stages.

## Learning

Observing the world and making a mental model. Adults do this by reading, by
observing others. Children learn by doing things.

Role-play, drills and games have been imporant in practice for centuries.

Practice dealing with emergencies: either at 3AM or scheduled.

## Tips

Run them like a D&D campaign. Put team in a room for a few hours. Appoint a
dungeon master and rotate the role regularly.

The DM plans the scenario before hand, and explains the problem. If you have a
robust environment, break production. Monitor and track events during the course
of the exercise. Conduct the postmortem.

Pass on knowledge by doing and practice!

Wouldn't it be interesting to use this to interview people?

Hopefully this exercise will result in a reduction of MTTR.

## Teams

Think about how you want your team structures. In D&D, a party of 4 dwarves
wouldn't work very well. Balanced teams are as important as balanced parties.

Can we distil and describe the attributes of team members like we do in
roleplaying games.

- Dwarves = specialists
- Wizards = devs
- Elves = sysadmins
- Humans = generalists

Specialists have extremely high skills in one area.

Generalists have a wide range of skills but may not be expert in any particular
field.

Just like a D&D party, a team need to be balanced and diverse.

## Q&A

> Performing tasks should be a function of skill, not of job description.

# Matt Palmer on SOA Everywhere

More about microservices architecture than the traditional gigantic SOAP
monster.

Anchor started in 2000 (no Twitter and Facebook, Google didn't matter). They
grew and needed to build systems (tcl and python tools talking to customer DB,
rt, wiki, physical asset tracking, config management, etc.) Wind up with a
complicated [set of] system, circular dependancies, etc. Plethora of interfaces
direct Postgres DB access, RESTful, XML-RPC, etc. No integration testing.

Upgrading RT 3.8 to 4.0 broke almost everything; everyone has learned "don't
touch anything" (except Matt because he's the boss). Stagnation.

Solution: rebuild with SOA

- loosely-coupled RESTful APIs on all data.

- Mandated consistent core behaviour for all APIs. Allows you to learn the whole
  system (rather than each part).

- Conformance test suites; they are the documentation/spec.

New architecture is horizontal, with an API service for each functional unit.

Consistent interface to everything, easier to learn. RESTful, JSON, document
formatting, common attributes, authentication, etc. Allows a service directory,
common library infrastructure.

## How?

Talk about it incessantly until everyone is sick of the topic. Nut out all of
the issues. Write a spec based on discussions.

Build an API based on it and discover the bits you missed. Iterate.

Build consumers, to help discover problems, etc.

Provide tutorials and examples for everyone to use. Unexpected use cases
(vendor import process is broken, use the API instead and things work).

Provide client libraries for talking to your APIs.

Provide a framework for building more, additonal APIs. A lot of commonalities
between APIs can be implemented in common too.

Provide lots of documentation, especially "getting started".

## Results

Managed to cut across on time, in spite of a few teething problems.

> The proof of a transition project is that you don't go back.

Less division between support staff and developers. People working together,
empowerment, etc.

## Q&A

Tools and systems to check and enforce consistency?

> Small organisation, so social enforcement is reliable.
>
> However, a lot of the consistency requirements are testable. E.g., common
> representations, attributes, etc. These sorts of issues are readily testable.

Anything that was too hard?

> Haven't found anything, yet. REST is good data and state changes and such.
>
> A few situations with many-to-many relationships were tricky, but using
> consumer-focussed design to guide making these workable (possibly ignoring
> the underlying craziness).

Layering?

> The API services are the single point of truth for specific types of data.
> Some access the same backends, but focus on different parts.

Limiting.

> Built in load limiting and horizontal scalability from the start.

Organisations build systems which reflect their communication structures.

> Yes. It is.

Versioning APIs?

> One of the first things that was discussed.
>
> Code uses semantic versioning. Responses all include software version
> information.
>
> Clients can request specific versions.
>
> Rules for deprecation of specific features, etc.

Did you consider available models for the data in your domain?

> Yes, but there was nothing out there that felt right. Only needed 5% of
> OAuth, for example.
>
> There are lots of APIs, almost all of them do things their own way. There
> aren't any standards until you get to things like SOAP.

# Ignite Talks

## REA lead guy

Teach someone to fish they eat for a day, etc.

Devops teams seem to self-limit sizes.

Flow and afforances for creativity. Env affordances are aspects which promote
or enable actions.

Information radiators: dashboards, etc. Give info to the knowledgable and
promote learning amongst others.

Popup classes

Brownbag classes: more formal.

Kata sessions: everyone brings a small (3 minutes) to share.

Dojos: longer, may involve pre- and post-work.

Hackdays: larger still, form adhoc teams, address problems.

Should share as much information in these processes as possible; enough to make
you feel uncomfortable. Prevent the presence of high priests.

Don't share your financial servers root password, but share that there are two
and located in X and Y. They can learn from the architecture, etc.

## Dr. Liming Zhu

Development background (from NICTA). Operation of software at scale in the cloud
requires engineering specifically.

80% of outages caused by people/process maturity issues. Mitigations often cause
or exacerbate large issues.

Log analysis, static configuration analysis, etc.

Treat operations as set of steps:

- Executed by fault-prone agents
- Which use and require fault-prone resources.
- ?
- ?

Three ideas:

- Undo-framework and undo-ability of operations:

    - A wrapper around AWS API which can undo operations.
    - Use AI planning to check undo-ability of operations

- Model, track, and simulate operations:

    - Monitor steps and verify post-conditions.
    - Use tracked process context for error diagnosis and recovery.
    - Simulate large-scale operations: provide guidance on probably/time of
	  successful completion, help identify bottlenecks, etc.

- Mine and model existing processes from log data:

    - Mine a process from existing log files.
	
    - Detect deviations early or help error detection. Presumably real-time
  	  mining to detect deviations from model, etc.
  
## Trent

The Phoenix Project. Company in the book had a bus factor of one: Brent was the
single guy who was critical.

Increasing the number of Brents in your organisation can be expensive to grow.

Look for people who are collaborative, passionate and love to share information.
But Brent is still Brent, even with these people around. Allow Brent to work on
big picture, important work (not fire fighting).

20 people, lucky to do deploy a week. Now deploy 5 distinct components a day.

Question: how do we remunerate people based on value they bring, rather than
their job title?

# Open Spaces: Session One

## Cloud without guests and configuration management

Scrapping the towering stack of abstractions that is a app in a guest in a
hypervisor on metal. See Erlang on Xen, golang circuit, etc.

But containerisation, Solaris Zones, etc.

Looks like this is the direction some stuff is going.

Cutting out overheads by passing network layers straight to applications
(Intel's drivers). But talking about optimising for performance is a bit silly
when we're running Ruby and Python.

But VMs give more than abstraction: separation, security. And OS engineers have
done a lot in the last few decades.

Over arching question is: what are you optimising for?

Doing continuous delivery requires automation, push button, etc.

0VM based NaCl?

## Organisational Learning

How spread it foot with devops? Essentially devops organisations are learning
organisations.

From Maverick: measure everything wasn't helping, just growing the number of
people for numbers. Go from 12 layers of people to 3 layers.

Dunbar's number (150) limits size of social graphs, so spilt company into
business units. Build small clusters for products and make all the things for
your work. Everyone learn all the machines.

Organisational structures. Often decisions are zero sum. If you treat IT as a
cost centre then it always will be.

Incentivise fixing things (flat rate for on call, fix it and you get paid and
get to sleep). Can be problematic with established roles, etc.

Technical debt has an organisational parallel. Doing kanban, etc. can help
give value and measures to work, etc. Doing one point a week vs the five
everyone else does, clearly there's a problem.

Peter Senger, The Fifth Discipline.

- Personal mastery
- Mental models (shared metaphors from XP; jargon, etc.)
- Shared vision (expressed in the models)
- Team work
- Systems thinking? Didn't catch the fifth.

First responder. Train every week, won trophies but sucked at fires. Training
and learning aren't the same thing; we learn because we want to, not because
we're in a class room.

Maverick: staff reviewed managers every six months, public.

Mastery: learn one new thing every day.

Training/learning: from Seven Samurai: "if we were using swords, I'd kill you."

# Open Spaces: Session Two

## Configuration Management 2.0

Using Puppet for 3 years, killed master and using fabric to push configs out and
apply them as required. [Pallet][] (Clojure), [Ansible][] & [Salt][] (Python),
orchestration in Puppet. Wanting to unify the code for system configuration,
harding, etc. and whole stacks (CloudFormation, etc.)

[Ansible]: http://www.ansibleworks.com/
[Pallet]: http://palletops.com/
[Salt]: http://saltstack.com/

> Did a spike of Chef, did a spike of Puppet. Puppet won.

Minimise resource usage in tweaking 10,000 instances by doing things like
immutable servers. Don't tweak 10k, just redeploy instances. [animator][] to
make AMIs.

[animator]: https://github.com/Netflix/aminator

Some of the configuration management tools will have/are having their lunch
eaten by tools like CloudFoundry, BOSH, etc. Continuous delivery, configuration
management, etc. are all coming together to result in a platform-oriented
approach. 

What's the lead time between having an idea to live? All of these technologies
-- configuration management, platform management, orchestration, etc. -- are
about automating and minimising this delay.

Better chance to achieve "security" using automation, policy as code, etc. than
with traditional pens 'n' paper security policies. Standardisation, consistency,
monitoring, reporting, etc.

Vagrant for testing Puppet, continuous integration, etc.

Combine chef client and nanite over Rabbit MQ. Sounds kind of salt-ish.

Plugging all the things into MCollective and get a message queue by accident.

1. Configuration management.
2. Orchestration (because configuring a single system isn't enough).
3. We need monitoring (so we can describe services and SLAs).

All the technologies are separate, do we need something that knows the system
end-to-end? Hooking monitoring up to orchestration up to configuration
management.

## Session Four: War stories

Telephone exchanges are feeble, monitoring software wedged the Glasgow phone
system by running twice.

Cron job: cron running as root to clean up a directory; root's $HOME is /. Three
or four days.

HPUX: rm -rf followed symlinks; put a symlink to / in home directory.

/ full, move something big, /lib say, onto a separate partition.

New job; we need a UPS for all the servers. Configure network alerts but the
switch wasn't on the UPS.

Why is crontab -r so close to crontab -e? Or at least ask for confirmation.

