---
title   :
categories  : [lca2011]
---

Lazy management: do the bear minimum work, *over the long term*.

IRAP: give you a certificate of compliance.

1. PSM: 
2. ISM: DSD?
3. PCIS: 

Primary and secondary sites. 200 pieces of kit. Multiple redundant paths.
Single point of entry/exit.

Services:
---------

Web browser, including content filtering.
Emil (SMTP) including anti-spam
DNS: public, gateway, business partners
Business partner connections: 20+ links to partners, etc.

- Fireall admin - multiple vendors
- IDS/IPS administration
- Router/swtich administration

- Lots of incidents, problems, changes
- external hosting intra: reverse proxies, SSL decryption, A/V checking
- XML messaging gateways
- Documentation

- Certification - Huge amount of work
  - Need to change passwords when someone leaves, also need a piece of paper
    telling you to do that.

No security: trying to get to a level of assurance that you are comfortable
with. Checklists, etc.

Love documentation; it avoids having to answer questions.

Openness: [some] client staff have access to Nagios, Cacti, [read-only] admin
interfaces. Saves huge amount of time (answering questions, etc.) Un-needed
secrecy *hurts* security, owning up beats the crap out of the relationship.

Each B2B link has a "link document" which describes the link, firewall between
them, etc., etc. They've had clients use these through months of meetings and
planning and then come to them for implementation. Has saved months in some
cases.

Try to make sure that anything hidden really is secret/classified/etc.

Firewall
--------

1. Live rules running on the devices.
2. Exported to SVN, viewable to client via web.
3. Wiki page of B2B "link documents".

Naming and Addressing
---------------------

1. IP Plan
2. Multi-split DNS
3. Public space but with many "private" ranges and a lot of NAT :(

Lots and lots and lots of NAT -- some TCP connections involve 5 different IP
addresses.

Web Browse
----------

Blue Coat ProxySG Appliance. SSL intercept aka "Man in the Middle"

Blue Coat Web Content Filtering

Blue Coat Anti-virus appliances

Use their rulesets, don't do anything else unless absolutely forced to by the
client.

Email
-----

Axway Mailgate SMTP appliance

Very strong tagging/polic capability

Anti-spam: IP rep filtering, SMTP checkss

Approx 100K legit emails per day, 7% spam, > 80% connections rejected.

Block a hell of a lot more email is rejected than accepted.

Passwords
---------

Huge variety of devices: at one point included literally one of everything
you're allowed to use. And many of each. Use a password file.

- NetFlow - "historical tcpdump".
- SourceFile - IPS/IDS. Based on Snort
- syslog-ng writing to where they're going to stay forever /archive/yyyy-mm-dd/*
- ArcSight - SIEM
- Lime