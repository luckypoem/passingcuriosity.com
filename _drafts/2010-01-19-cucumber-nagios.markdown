---
---

[Behaviour driven monitoring with cucumber-nagios][talk] by Lindsay Holmwood.

[talk]: http://sysadmin.miniconf.org/presentations10.html#07

Using [cucumber](http://cukes.info/) to write tests in English. Results are
formatted for [Nagios](http://www.nagios.org/).


{% highlight sh %}
# Install 
gem install cucumber-nagios

# Create a new project
cucumber-nagios-gen project miniconf
cd miniconfg
gem bundle

# Create a feature to test
cucumber-nagios-gen feature sysadmin.miniconf.navigation
{% endhighlight %}


Cucumber is excellent for verifying that systems (DNS, for example) behave
correctly (someone from Sun).

Puppet == build tool

Cucumber == testing tool

Using Cucumber as a testing engine allows you to switch from Puppet to
CFengine, Chef, etc.

Caveats
-------

**AJAX** Mechanize is not a browser. It doesn't do JavaScript, so it can be
difficult to test AJAX-y apps unless they are written with progressive
enhancement.

**Existing features and steps** Using existing stories can be hard if they're
based on the tool-specific (RoR, etc) type things.

**Is my server up?** What about dead apps, VMs?

**Can I see my app?** What if part of it is broken?

Ask the right questions
-----------------------

Cucumber and nagios help you to ask the right questions.

Continuous integration and integration. 

Continuous integration: checkout, build, test, notify. As sysadmins, we don't
need to checkout or build, just test and notify.

Current tests are generally "can I see my app?" Think about what that would
mean to do in your testing environment. It would make no sense if that were
your only test!

This is not new. I can already do this with X, Y, Z. Yes, but Cucumber makes
this workflow simpler and easier to manage. Making reuse of existing checks
reusable.

Less code == less bugs (at 3 AM)

Telephony
---------

The telephony-system-test is a library for testing telephony systems with
Cucumber.

