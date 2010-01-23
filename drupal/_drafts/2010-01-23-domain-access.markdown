---
title    : Domain Access
tags     : [drupal, domain, access, sites, override, permissions]
location : Wellington, New Zealand
---

Managing affiliated websites with a head-office/branches business structure

[Modica][modica] for the [New Zealand Credit Union][nzcu]

[modica]: http://www.modicagroup.com/
[nzcu]: http://beta.nzcu.co.nz/

Problem: Client (New Zealand Credit Union) with a head-office and a bunch of
branches/franchisees. Each branch has its own web-site, with at least some
content supplied head-office.

1 Head Office (NZCU) and 9 branches; with the head office having a lot of say
in what branches do (products), but the branches can control which promotions
they participate in, etc.

Challenges
----------

1. Running multiple sites: 9 different websites with the same functionality
   and affiliate as well as individual content.

2. Permissions to support: head-office pushing content onto branch sites
   without giving branches access to edit.

   Branches *also* adding and editing their own content.

3. Interdependent menus: head-office manages a menu structure which applies to
   all affiliate sites.

4. Permissions at sub-node level: head-office sets up products which branches
   can opt to sell, but each can make customisations to rates, fees, etc. that
   apply through them.

Solution
--------

For 1-4: the [domain access][domain] suite of modules provides a solution for
all challenges.

[domain]: http://drupal.org/project/domain

Only three menus, but domain access is smart enough to add menu entries for
each domain when domain access is active for the node.

Sign-off week 1, design week 2, live two weeks later. Domain access actually
did what it said, so it didn't require a lot of hacking.

One "primary" domain, with an unlimited number of "other" domains.

Products use a bunch of CCK fields (rate, notes, etc) for each branch,
published for all sites, but using field permissions to restrict editing to
these fields from the branches.

Can separate specific tables (with another module) per domain. Used this to
allow each site to have its own pretty URLs without `-1`, etc. suffixes on the
same page across the sites.

Finale
------

Domain access highly recommended! Plug and play, no bugs or issues
encountered. Well written, easy to hook into for custom alterations. Large
range of related modules to add specific functionality.