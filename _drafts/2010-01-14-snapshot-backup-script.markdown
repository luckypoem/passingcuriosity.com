---
layout : post
title : A simple "snapshot" backup script
tags : [code, shell, backup, archive]
location : Perth, Western Australia
---

Here's one of the scripts I use to automate backup retrieval. As with creating the backups, this could do with integrating some encryption.

{% highlight sh %}
#!/usr/bin/env bash

BACKUPS=/Users/thsutton/backups/kindy/

CURR=`mktemp -t backupkindy`
scp kindydancetime.com.au:backup/current.txt "$CURR"
NEXT=`cat "$CURR" | tail -1`
rm "$CURR"

echo "$NEXT"

pushd "$BACKUPS" > /dev/null
scp "kindydancetime.com.au:\"backup/$NEXT\"" "$NEXT"
popd > /dev/null

{% endhighlight %}