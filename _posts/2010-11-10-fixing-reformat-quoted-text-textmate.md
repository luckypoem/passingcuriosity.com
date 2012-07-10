---
layout: post
title: Fixing the "Reformat Quoted Text" command in TextMate
category: development
tags: textmate, intel, mac, commands, architecture
location: Perth, Western Australia
excerpt: |
  How to fix the "Reformat Quoted Text" command in TextMate so that it works 
  on Intel Macs (without installing Rosetta).
---

TextMate is a pretty cool editor (where is 2.0!?!) with good supports for
editing a bunch of formats including e-mail-style text documents. Part of this
support is a "Reformat Quoted Text" command which uses the `par` command to
wrap text while maintaining line prefixes and suffixes. Alas, the version of
the `par` command that ships with TextMate is for PPC Macs.

This means that to reformat quoted text you must either be using a PPC Mac
(ha!), install Rosetta (HA HA HA!), or fix the command. This last is both the
easiest and best of these options.

1. Download the [source code of `par`][1].

2. Compile it according to [the instructions][2].

3. Replace the `par` executable file in your TextMate Mail.bundle (mine was
   located in 
   [here][3]) 
   with the newly compiled executable.

4. There is no step four. (Feel free to profit here.)

[1]: http://www.nicemice.net/par/
[2]: http://www.nicemice.net/par/#building
[3]: file:///Applications/TextMate.app/Contents/SharedSupport/Bundles/Mail.tmbundle/Support/bin/
