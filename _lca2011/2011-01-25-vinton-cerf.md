---
layout      : post
title       : Vinton Cerf
categories  : [lca2011]
tags        : [internet, network]
location    : Brisbane, Queensland
excerpt     : |
  Vinton G. Cerf's keynote session: Re-imagining the Internet.
---

The Internet that we use currently can and should develop further in different
ways.

ARPANET (Dec 1969) had four nodes. Now 700-800 M machines, 4.5 B mobiles
(15-20% online enabled), etc.

Important that there was no particular application in mind while designing the
Internet, so it's not shackled to anything else. Layered architecture was
inherited from ARPANET segregates implementation changes. Non-national IP
address structure: military didn't know where it'd be used, and didn't want to
ask an adversary for addresses. :-)

Open access, open standards, no IP claims on TCP/IP. Commercialisation drivers
(led to massive infrastructure investment).

Growing now: IPv6 in parallel with IPv4. IDN, DNSSEC, RPKI, sensor networks,
smart grids, mobile devices. 

IPocalypse probably in Jan/Feb 2911. Likely in RIA's 2012.

Problems
--------

Spam, viruses, DOS/DDOS, social engineering, phishing, pharming, password,
address squatting, human error.

Lots of the problems are social.

Origins: weak operating systems, naive browsers with too much privilege
(biggest hole currently), poor access control practices, improper
configuration, botnets, hackers/crime/state-sponsored cyberwarfare.

Privacy problems: lax user behaviours (social networking), weak protection by
organisations and governments (naturally gathered data, account information,
usage records, etc.), invasive devices (camphones, GPS tracking, RFID, CCTV).

Clouds
------

At the state in the cloud world now that the Internet was in 1983: many
different implementations each built differently with different functionality.
Each of the clouds is independent of each other in the same way the networks
used to be.

How can we move things between clouds when they may have different protocol
support, access control, semantics, reference, protecting them from internal
and external threats.

Open Problems
-------------

Security at all levels.

Operating system design. Internet "Erlang" formulas.

QOS debates (smart routers?)

Internationalised DOmain Names (ccTLDs & GTLDs)

Distributed algorithms - particularly with clouds

Presence

Mobility, persistence (processes, connections, references)

Multihoming, multipath routing

Broadcast utilisation

Mesh and sensor networks.


The big thing: mobility, multihoming, multipath routing. The TCP/IP split
occurred when it became evident that some streams need speed, not reliability.
The decision to re-use the IP addressing in TCP was a mistake, should use
something like the mobile telephone system where the TCP address is a label
bound -- for now -- to an IP address. Also apply to multihoming.

It would be nice to be able to use multipaths more effectively.

Using broadcast media more effectively would be good: taking something as
inherently broadcast as radio and using it for point to point is weird and
wasteful.

Authentication, identity, authorisation.

Multi-core algorithms.

Delay and disruption tolerance.

Internet Governance: law enforcement, policy development, homologation,
facilitation of electronic commerce, privacy and confidentiality.

Performance: latency, throughput, resilience, rate management vs CWND flow
control, route convergence. Finding a way to discover and determine problems.

Addressing: there's no reason to stop addressing at the machine's interface.
Which objects should be addressable? Perhaps individual files? New bindings of
IP to identifiers (and a new DNS?)

Challenges
----------

Intellectual property issues: digital information is easy to duplication and
distribute.

Semantic web

Complex objects only meaningful digitally.

Increasingly worried that we invest enormous effort in creating digital
objects that depend entirely on the continued availability and operability of
applications. Archiving, longevity, continued access, etc. See also: slightly
old hardware. What do we want to be remembered as? How do we *expect* to be
remembered.

Interplanetary Internet
-----------------------

Speed of light is too slow (3:30 - 20 minutes each way Earth-Mars). Developed
new protocols with delay and disruption support built-in. Hoping to grow an
interplanetary backbone by repurposing craft that have accomplished their
missions.

Questions
=========

More concerned with maintaining the ability to interpret bits, rather than the
continued availability of the bits themselves (i.e. the media issue).

Buffer bloat adversely affecting congestion control (large buffers delaying
feedback loop). Need to use just enough memory.

Spend time convincing people to write software that needs writing. Spend time
on campuses working with grad students and professors to find the hard
problems that still need to be addressed.
