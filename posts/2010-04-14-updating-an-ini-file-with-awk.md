---
layout: post
title: Updating an INI file with AWK
tags: programing, awk, text
categories: [programing]
location: Perth, Western Australia
excerpt: 
  A colleague asked if I knew a way to edit a line in a particular section of 
  a .ini file in a shell script. There are plenty of ways to do this, but my
  answer is in AWK.
---

The problem is simple: update a specific line in a specific section of a
`.ini` file in a shell script. The file (a configuration file for Gitosis)
looks something like this:

``````ini
[gitosis]


[repo repo1]
description = This is a repository with stuff in it
owner = A User

[repo repo2]
description = Another repository with stuff in it
owner = Another User

[repo docs]
description = Documentation
owner = A Manager

[group developers]
writable = repo1 repo2 docs
members = auser anotheruser

[group managers]
writable = docs
readonly = repo1
``````

The goal is to append a value to the `writable` line in the `group developers`
section (leaving the rest of the lines alone). Any solution will need to do
the following:

1. find the `group developers` section; then
2. find the `writable` line in that section, if any, and update it.

This is simple to do in AWK:

1. a rule sets a flag when you enter the `group developers` section;
2. another updates the `writable` line when the flag is set;
3. a thirds rule clears the flag when you leave the section;
4. a final rule outputs other lines unchanged (we use a flag to skip the lines
   modified and output above).

Here's the code:

``````awk
# Clear the flag
BEGIN {
	processing = 0;
}

# Entering the section, set the flag
/^\[group developers/ {
	processing = 1;
}
	
# Modify the line, if the flag is set
/^writable = / {
	if (processing) {
	    print $0" foo";
		skip = 1;
	}
}

# Clear the section flag (as we're in a new section)
/^\[$/ {
	processing = 0;
}

# Output a line (that we didn't output above)
/.*/ {
	if (skip)
	    skip = 0;
	else
		print $0;
}
``````

Easy!
