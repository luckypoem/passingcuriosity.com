---
wordpressid: 1155
wordpressurl: http://passingcuriosity.com/?p=1155
layout: post
title: Specifying a UNIX socket using MySQL with Django
tags: mysql, django, unix, socket, configuration
location: Perth, Western Australia
excerpt: |
  Configuring Django to connect to MySQL with a socket according to the 
  official documentation works fine (for me), but it breaks the dbshell 
  command (for me). This is how I configured it so that Django works and so
  does the dbshell command.
---

It is sometimes necessary to specify a particular UNIX socket for
[MySQL][mysql] [client libraries][mysqldb] to use (for example, when you have
more than one MySQL server on the machine and wish to use one other than the
default). The canonical way to specify a particular UNIX socket for
[Django][django] is to give the full path as the `DATABASE_HOST` option in the
project settings file[^1]:

[mysql]: http://mysql.com/
[mysqldb]: http://mysql-python.sourceforge.net/
[django]: http://www.djangoproject.com/

[^1]: See, for example, the [documentation for
DATABASE_HOST](http://docs.djangoproject.com/en/dev/ref/settings/#database-host)

{% highlight python %}
DATABASE_HOST = '/tmp/mysql.dev.sock'
{% endhighlight %}

This works properly and reliably for Django itself but, on my system at least,
it also breaks the `manage.py dbshell` command: rather than starting and
connecting to the correct database, the `mysql` errors out with the message

> ERROR 2005 (HY000): Unknown MySQL server host '/tmp/mysql.dev.sock' (1)

The reason for this should be fairly obvious: `/tmp/mysql.dev.sock` is not, in
fact, a host name. In fact, this whole solution seems pretty wacky to me (why
put a value that is distinctly *not* a host name in the "hostname" value?).
The correct way to specify a UNIX socket for the MySQL client libraries to
connect to is using the `DATABASE_OPTIONS` ([most of] the options can be seen
in the [MySQLdb API documentation][mysqldb-opts]):

{% highlight python %}
DATABASE_OPTIONS = {
    'unix_socket' : '/tmp/mysql.dev.sock',
}
{% endhighlight %}

Doing so ensures that Django is able to connect (using a UNIX socket on the
local host) *and* that the `mysql` shell is able to connect (also using a UNIX
socket on the local host). Everything works, everyone is happy, and all of our
options have values that actually make sense. Hoorah!

[mysqldb-opts]: http://mysql-python.sourceforge.net/MySQLdb-1.2.2/public/MySQLdb.connections.Connection-class.html#__init__
