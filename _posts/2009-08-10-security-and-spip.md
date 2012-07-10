--- 
wordpressid: 1864
layout: post
title: Security and SPIP
wordpressurl: http://passingcuriosity.com/?p=1864
---
[SPIP](http://www.spip.net/) is an open source content management system written in PHP. It was originally designed to use a MySQL, but now supports [a number of SQL databases](http://www.spip.net/en_article3837.html) including PostgreSQL and SQLite. Like most software systems, it sometimes has bugs and flaws and, like many web-based systems, these can sometimes lead to exploitable security holes. This post describes the latest security problem in SPIP (which [resulted in the released of SPIP 2.0.9](http://www.spip-contrib.net/SPIP-Security-Alert-new-version)) and how to help reduce the risk of your SPIP sites being hacked using similar flaws in the future.

<!--more-->

## A coincidence of vulnerabilities ##

On the 5th of August, one of our clients forwarded me a notification that Google had detected malware on their web-site. After a quick look at the site, I discovered that someone had injected an `<iframe>` into the site -- the title of a news item, to be precise. I had a look in the administration interface and found that the title of that news item actually did contain the `<iframe>` code. At first I thought that this was simply a matter of some attacker guessing or stealing a password, but there were no FTP accesses during that period and the only SPIP users had strong passwords. This was when I started to get worried.

I took a backup of the whole site over FTP and had a quick `grep`, but couldn't find anything that had changed appreciably. Anything, that is, other than the `config/` directory. Somehow, the site had been switched from using MySQL to SQlite2. Asking around the office made it clear that none of *us* would do something so strange (storing SQLite databases in the web-root is a pretty strange thing to do in the first place!) so I was stumped, especially because this SQLite database was full of the correct content, ignoring extraneous `<iframe>`s.

I jumped on the phone to the hosting company and asked them to check their web server logs and Ender (their excellent system administrator) quickly found a bunch of accesses to `/ecrire/` (the SPIP administration interface) which looked odd (especially with all the `..`s and `//`s in `GET` parameters), especially seeing as they came from Saudi Arabia. He dumped the those entries and e-mailed them to me (and reset every password associated with the account). Now I had something to work on.

Filtering out the various noise that you get in http log files (css files, javascript files, etc.), it was clear that something *really* strange was going on. The attacker, whomever they were, seemed to be exploiting a path escaping bug in SPIP (investigated by Pierre Rousset, who finished his internship with us last week) which, in combination with an authorisation bug, allowed anyone to cause SPIP to make a backup file (and write it with any filename the attacker chooses, and in any directory the server can write to). To make matters even worse, they could use *another* security hole in SPIP to begin a re-install and they were able to create their very own SQLite database and run through the installation procedure. After restoring the backup that they triggered, there was very little way to tell that the site had been hijacked!

## Preventing exploitation ##

These flaws are very serious and, while the fix is very short ([the patch](http://fil.rezo.net/secu-14346-14350+14354.patch) modifies four lines of code in three files), they seem to me, to be indicative of a design flaw that can be seen in many web applications: pieces of code are responsible for their own input validation and their own authentication and/or authorisation checking. Exacerbating the problem is the fact that SPIP encourages users to install it with an insecure configuration. Everyone say it together: if the application can modify its code, then it is insecure.

Preventing the site from being hijacked is reasonably simple: all you need to do is prevent SPIP from modifying `config/` and the files and folders in it. That's it: just `chmod -R -w config/`. Done!

For better security, make sure that `config/` and it's contents are **not** owned by the web-server user (usually `nobody`, `www-data` or similar). Otherwise, the crafty attacker may be able to `chmod` them then trigger the original bug. If you're paranoid like me, you'll also want to put add a number of things to your Apache configuration  (or `.htaccess` file): 

- Turn off automatic directory indexes; all they do is leak information to a potential attacker.
- Turn off PHP execution within `IMG/`, `local/`, and `tmp/`. Any script in those directories is going to be `include()`ed and doesn't need to be directly executable.
- Deny all access to your `tmp/` directory, either with `Deny from all`, or by using `RewriteRule`s.

For the even more paranoid, you can try to:

- [Rename `spip.php`](http://my.opera.com/tech-nova/blog/2008/07/04/no-i-dont-like-spip), `squelettes/` and `ecrire/` to reduce your exposure to automated attacks.
- Suppress the inclusion of produce names and version numbers (in particular, the `Composed-By:` header which identifies the version SPIP and of all of the installed plugins).

Needless to say, I'm going to keep doing most of these things on my SPIP sites, even after the release of the newly re-secured version 2.0.9.

## Conclusion ##

There are several morals that, I think, can be taken from this story: 

1. An application should not be able to modify its own code. If it "needs" to, then it is going to be insecure.

   There are a variety of reasons that the SPIP developers don't agree with this -- and that is, of course, their prerogative -- but, as we all discovered last week, this leaves them, and their users, vulnerable.

2. An application should leave checking user authentication or authorisation to "action" code. The application's framework should require authentication for *all* actions and a sensible default authorisation policy. It should allow these defaults to be overridden, certainly; but the default should be for secure, not insecure. It is easier to allow what is necessary, than deny what is not.

   This has been been good advice since it was proposed by Saltzer and Schroeder in their 1974 paper [The protection of information in computer systems](http://scholar.google.com/scholar?cluster=3120807813057714038&hl=en).

3. A quick and effect response from the developers can turn a potential disaster into a feel good moment. I, for one, feel a bit more forgiving of this sort of bug when it dealt with and resolved as quickly as it was.

This article could be read as rather harsh criticism of SPIP, but it shouldn't be. These are pretty common classes of flaws -- incorrect input validation and ineffective user authorisation -- and can be difficult to get right. Input validation, in particular, can be a nightmare of encoding and decoding bugs and vulnerabilities, before you can even *start* to think about application-specific validation rules.

On the *glowingly complementary* side of things: the SPIP developers did an exceptionally good job of finding and fixing the problem. Within a day of my initial report, they'd [released SPIP 2.0.9](http://www.spip-contrib.net/SPIP-Security-Alert-new-version), a patch for people who don't want to upgrade, and an updated "[security screen](http://www.spip.net/en_article4201.html)" script which blocks exploits without fixing the problems). Bravo SPIP team!

*Update:* Added a mention of Pierre Rousset.
