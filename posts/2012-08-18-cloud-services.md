---
title: PyconAU 2012: Implementing a cloud service in Python
tags: PyconAU 2012, Python, cloud
location: Hobart, Tasmania
excerpt: Notes from a talk at Pycon AU 2012.
---

John Barham from SlickDNS.com.

A bit of blurb about "the cloud".

Using

- Using ECS and RDS for "main server".
- DNS servers on linode.
- Postmark for email.
- `fabric`
- `daemontools`

- `celery` on RabbitMQ. Decoupling form submission from processing to improve
  user experience; event logging (gathering metrics).

- `memcached` for caching with Django's built-in support; cache anonymous
  pages.

- Browser caching: embed timestamps in the static media URLs, resources can be
  cached forever as the URL will change (http://gist.github.com/3375913).

- API. Good old REST vs SOAP and JSON vs XML blah. HTTP authentication: basic
  over HTTPS.

- Logging: CloudWatch to monitor EC2, is pretty heavyweight; StatHat for
  statistics and event logging.

See "The S Stands for Simple"
