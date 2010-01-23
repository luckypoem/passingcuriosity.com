---
title: "No medium found: when it's time to stop trying to read strerror's mind"
---

No medium found: when it's time to stop trying to read strerror's mind by
Peter Miller


Motivation
----------

Somewhere in kernel land, the kernel knows what is wrong: it decided to take
the `else` fork. Wouldn't it be good if you could get to that?

over 500 systems calls * multiple errors each = 8 bits of errno?

Not really practicable in the case of version 7 UNIX ('85-ish). 

Twenty five years later, it is actually here.

Error Messages as Finesse
-------------------------

One of the things we drop on the floor when the deadlines are coming. But it's
the difference between calling tech support and ???.

Consider "Segmentation fault (core dumped)".

Some lecturer at Sydney in 79: "There's no point handling errors you can't do
anything about." Everyone can use a debugger.

`Can't open file` doesn't help. Which file and why? We can use `gdb`,
`strace`, etc. but they probably won't be installed on users' machines. And
this is what will wind up in the bug report.

It's precisely when it "can't ever go wrong" that you need to supply more
information. 

Using `perror` isn't necessarily enough.

What about `strerror(errno)`? 

There weren't dump people, so maybe they were dumb error messages?

If you're the one reading the bug report, you'll really want to have more
information!

Limitations of strerror
-----------------------

* Returns a string describing the error *number*. An eight bit number.
* The kernel knows *what* went wrong (and it would be awesome if we knew too).
* The "filename problem" (you need to pass the filename around, just in case
  you need to report an error with it)


Level infinity tech support.

After 25 years:

* The users still don't get it.
* Now there is /proc/ (which lets you introspect about your fd's, etc.) If
  your /proc is broken, you can use `lsof` to play with the kernel's private
  parts more intimately.

Using `libexplain`, you get an `explain_foo()` function for each and every
system call `foo()`. The `libexplain` functions take all the same arguments as
the system calls. Where appropriate (the flags to `open()`, for instance),
it'll process things before outputting.

It also lets you explain a specific `errno`: `explain_errno_foo(...,er)`.

Also has `explain_foo_or_dir()` versions, which exits for you.