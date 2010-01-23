---
title: How search.gmane.org works
---

Gmane is an archive of public mailing lists. Provides a common interface and a
persistent archive that won't vanish when the list does.

Lars ??? started it in '06. Hosted in Oslo, Norway. 

Because it's just text, there are too many problems with bandwidth. 

100% F/OSS. On the search side:

- libgmime
- Xapian



12 k lists, 92 mill messages (74 million searchable). 35-40 k msgs a day.
Marked as "no archive" only keeps messages for a few days so that people can
read along, but they aren't searchable. Groups can also be marked
non-searchable.

Search first added Dec 2002. Called we:search, written by Lars in a weekend. Problem: fragmented on update, so had to reindex periodically. 

Current box (rain): 2U athlon 64 2GHz, 3GB RAM, ~800GB, INN spool NFS mounted.

New box (plane): 1U dual-core opteron 2.4GHz (plus other changes)

Date spool
----------

Make Xapian numeric document ids match date order. Provides very fast "sort by
date": results for unordered queries already *are* in date order. Similar
tricks can be used with other global orderings.

Gmane does it in reverse order (older first) so it has to scan through the
whole result set, but this is still better.

Format
------

One file per minute: `/ispool/datespool/2009/09/21/13/10`. There are messages
dating in the '50s and '60s, but that's probably bad clocks. The oldest
genuine message is probably from the '70s. 

Contents:

> macro@example.com
> 125230832
> 1426
> From: macro@example.com
> Subject: Foo bar bax
> Xref: news.gmae.org ....

From (for searching, the header will be encrypted if req.), time (UNIX stamp),
length in bytes, headers, body.

Creating the Date Spool
-----------------------

1. Parse all msgs in INN spool (parsed libgmime).
2. create list of <time_t> <path>.
3. Sort it.
4. Create date spool in that order (so the reads are pretty much ordered).
5. Build xapian index from datespool.

imports will perturb the ordering of the spool on disc, so rebuild it
occasionally.

Updating
--------

Import and update into the datespool and also an update pool.
Nightly, make an "update" index which will be merged into the "live" index.
Periodically, create a new index from the data spool.

Spelling
--------

Using Xapian's built-in spelling correction facilities.

Give is a list of "correct" words. You can just give it a word list, or use
your corpus. Using a corpus like gmane won't work (as it's full of
misspellings, and other languages), and a wordlist won't work (no jargon,
etc).

Currently dumping the corpus word list and culling the least frequently used.

Stemming
--------

Currently assumes English.

Removal of linguistic suffixes.

Aim to improve recall. 

Stem by default (avoid capitalised words and quoted).

Stop words
----------

Do suppress stop words (except in quotes).

Filtering
---------

Filter by author name or email.

Also by group or hierarchy.

Sorting
-------

Sort by rel, date (asc, desc.

Future Plans
------------

Commission the new server.

Search API so that people can use it externally (use the old server for api).

Easier group search (`cpan`, not just `gmane.comp.lang.perl.cpan.*`)

More frequent updates.

Xapian BOF on Thursday. 

Questions
---------

Date spool isn't backed up as it can be recreated. The INN spool is backup (by
virtue of being on multiple machines).

Doesn't know what file system it's stored on (though the current and new are
different). ReiserFS did cause a lot of kernel panics early on, so they left
it.

Xapian uses a BTree key/value store internally. It *can* store the document --
theres a "some stuff" slot in the Xapian entries -- but it currently stores
just enough to create the list entry.

Amongst the most challenging problems has been finding bugs in libgmime --
processing many millions of documents and it crashes after hours.