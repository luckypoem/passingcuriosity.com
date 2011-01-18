---
layout      : post
title       : Getting rid of Boot Camp volumes
categories  : [apple]
tags        : [osx, boot camp, ubuntu]
location    : Perth, Western Australia
excerpt     : |
  A short overview of my last few hours fighting to get rid of the Boot Camp,
  Ubuntu Linux and rEFIt volumes on my Macbook Pro with Snow Leopard. It was a 
  struggle, but I got there.
---

I've spent the last few hours fighting to get rid of the Boot Camp, Ubuntu
Linux and rEFIt volumes on my Macbook Pro. It was a struggle, but I got there
in the end. I don't want to think about this any more but Google and the
internets should probably know how to resolve this problem, so here are some
cursory notes.

I should probably say that I'm not sure who or what is to blame for the
problem described here. I suspect one, the other, or the combination of rEFIt
and Boot Camp but I'm not sure. I also blame Disk Utility for its rather
shocking lack of utility.

1. Used Boot Camp Assistant to create a partition for a Windows install (as if!)

2. Installed Ubuntu instead of Windows.

3. Installed rEFIt (I'm still not sure if it was necessary).

4. Got sick of all that space being wasted with an Ubuntu install I never use.

5. Deleted the various Linux partitions in Disk Utility.

6. Removed rEFIt (by changing the Boot Volume in System Preferences and 
   deleting the /efi/ folder).

7. Shrank the system volume.

8. Attempted to allocate the space that was the Linux partitions and the free
   space from the system volume to a new partition for data. This failed with 
   a *MediaKit reports partition (map) too small* error.

9. Attempted to grow the system volume to fill the whole disk. This too failed
   with a *MediaKit reports partition (map) too small* error.

10. Discovered by reading some truly mind-numbing Apple discussion forum
    threads and other old, ill-informed, and old-and-ill-informed hits from 
    Google that doing things manually using the command line tools may work.

11. Noticed from `diskutil list` that I had two EFI partitions (one *after* my
    system volume) and, as Disk Utility doesn't mention them, that this extra
    partition is the reason for the error (and that whomever chose to emit 
    that error in this case is a shit).

12. Became annoyed that `diskutil` doesn't seem to have a subcommand to delete
    (Why do Apple insist on calling them verbs?) slices and `fdisk` is nearly
    useless (unless you enjoy calculating disk geometry manually), but that it
    is possible to reformat a volume *and* change its type by erasing it like 
    so:

        sudo diskutil eraseVolume HFS+ UntitledHFS disk0s4

13. Deleted this new volume in Disk Utility and created a new one filling the
    entire free space.

Hope this helps someone else.
