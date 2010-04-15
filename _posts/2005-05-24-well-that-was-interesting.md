--- 
wordpress_id: 1480
layout: post
title: Well that was interesting...
wordpress_url: http://passingcuriosity.com/2005/well-that-was-interesting/
---
I've just been poking at my iPod mini's innards (in the software sense) and had a bit of a scare. It started when my quitting iTunes somehow managed to knacker something or other causing iTunes to crash on start-up, without fail. After a few attempts to fix it (including nuking my playlists, damn it!), I unplugged my iPod, and iTunes started working again.<br /><br />Mystified, I started poking around in the iPod volume on the shell and, let me tell you, it is a lot more interesting from the command line. In Finder, all you can see are the Calendars, Contacts and Notes folders. From the command line, you get all sorts of junk ('Desktop DB' and 'Desktop DF', the spotlight index, .Trashes, etc) including a folder called iPod_Control. In iPod_Control, there is all sorts of interesting stuff including the music files themselves (in 'iPod_Control/Music/') and some miscellaneous data (in 'iPod_Control/iTunes/').<br /><br />Nuking 'iPod_Control/iTunes/' had the effect of fixing my problem, with the side effect of making iTunes (and perhaps the iPod, I didn't check) unaware of the music on my iPod. I won't have time for a while, but I'm going to have to poke around in there some more...
