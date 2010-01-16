--- 
layout        : post
title         : Logging the locking in SPIP
wordpress_id  : 2077
wordpress_url : http://passingcuriosity.com/?p=2077
categories    : [spip]
excerpt       : |
  The rather hackish way I instrumented SPIP to record debugging
  information about its file locking to a remote syslog server.
---

At [work](http://bouncingorange.com/), we use
[SPIP](http://www.spip.net/) for the vast majority of our sites.
Almost all of them are on Linux shared hosting at our favourite local
hosting company [HostAway](http://www.hostaway.net.au/).
Unfortunately, we've been running into a recurring problem with some
of our SPIP 2.0 sites that is having a detrimental impact on the sites
(some requests block forever) and the servers (PHP FastCGI processes
blocking forever leading to resource starvation).

The problem, it seems, lies in SPIP's use of locking to serialise
access to a number of files containing cached data. In essence: SPIP
seems to deadlock when attempting to lock certain files in the `/tmp/`
directory. This hangs the PHP process (FastCGI, in our case) which
consumes resources and, eventually, prevents the web-servers from
being able to serve requests for PHP. To make a bad problem even
worse, we seem to be the only people to experience this problem.
Literally no-one else in the SPIP community has ever encountered it!

As a first step in trying to diagnose and resolve the problem, I've
instrumented the code that implement's SPIP's locking techniques to
log all locking operations. Thankfully, this is relatively easy as
SPIP wraps the actual [`flock`](http://php.net/flock) calls with its
own `spip_fopen_lock()` and `spip_fclose_unlock()` functions defined
in
[`/ecrire/inc/flock.php`](http://trac.rezo.net/trac/spip/browser/spip/ecrire/inc/flock.php).

I can't use the built in SPIP logging functions because they use the
locking functions I'm trying to instrument to prevent interleaving of
log messages. The obvious choice (and far superior to `spip_log()`, in
my opinion) is using the [syslog](http://en.wikipedia.org/wiki/Syslog)
protocol supported by pretty much everything that matters (i.e.
everything UNIX and lots of networking gear). Alas, PHP's built-in
[`syslog()`](http://php.net/syslog) function logs to the local syslog
daemon. Instead, I've used a small class that implements a [Pure PHP
syslog client](http://www.phpclasses.org/browse/file/12157.html).

Rather than copy-'n'-paste a bunch of code into the SPIP locking
functions, I've created a function to figure out what the message
should be[^1] and then log it. `logtrace()` creates a PHP backtrace
and inspects it to determine which function (lock or unlock) it is
logging and which function (of the dozen or so alternatives) called
it. Once it's figured that out, it uses a static instance of the
Syslog class to send the message to the log server. The code is
simple:

{% highlight php %}
<?php

require_once('syslog.php');

@define("_SYSLOG_SERVER", "192.168.1.1");

function logtrace() {
	// The syslog client
	static $log;
	if (! $log) {
		$pid = getmypid();
		$log = new Syslog();
		$log->SetProcess("PHP-$pid");
		$log->SetIpFrom($_SERVER['REMOTE_ADDR']);
	}

	// Get the functions from the backtrace
	$bt = debug_backtrace();
	$callee = $bt[1];
	$caller = $bt[2];
	
	// Build and log the message
	$func = $callee['function'].'('.$callee['args'][0] .')';
	$from = $caller['function'].'('. $caller['args'][0] .')';
	$log->Send(_SYSLOG_SERVER, "$func from $from");
}
{% endhighlight %}

With that defined, it's just a matter of adding a call to `logtrace()` to `spip_fopen_lock()` and `spip_fclose_unlock()` in `/ecrire/inc/flock.php` and we get log messages something like this[^2]:

>     Nov  3 13:54:07 server2.example.com WEBSERVER PHP-1234: www.example.com 10.10.10.10 spip_fopen_lock(../tmp/verifier_plugins.txt, ...) from lire_fichier(../tmp/verifier_plugins.txt, ...)
>     Nov  3 13:54:07 server2.example.com WEBSERVER PHP-1234: www.example.com 10.10.10.10 spip_fclose_unlock(Resource id #69, ...) from lire_fichier(../tmp/verifier_plugins.txt, ...)

Of course, this is not enough information to debug the locking problems -- I'll also need the IP address of the client and the PID of the PHP interpreter to distinguish interleaved messages from concurrent requests -- but it's a start.

[^1]: Note that the I'm including only the first argument in the log message. Why? Because the second argument to some of them is *the entire contents of the file*!
[^2]: Note that the theme I'm using is cutting off most of these log lines.
