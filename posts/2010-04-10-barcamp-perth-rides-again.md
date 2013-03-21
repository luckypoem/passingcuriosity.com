---
layout: post
title: Barcamp Perth rides again
tags: bcperth4, barcamp
categories: [barcamp]
location: Perth, Western Australia
excerpt: 
  Barcamp Perth 4.0 (or 2010, there seems to be some confusion) was held today
  at the Central Institute of Technology. Here are some notes about the day.
---

[Barcamp Perth 4.0][bcperth] (or 2010, it answers to both apparently) was held
today at the Central Institute of Technology. Thanks to the sponsors, the
organisers ([Matt][mattman] and [Darcy][sutto]) and the speakers, it was at
least as awesome as in previous years. There were a range of [topics][talks],
but this year seems to have continued the trend of largely technical talks.

[bcperth]: http://barcampperth.org/
[mattman]: http://twitter.com/mattman
[sutto]: http://twitter.com/Sutto
[talks]: http://barcampperth.org/talks

I'll give a brief summary of the talks I found particularly interesting below.
I think they're in order, but don't quote me on it.

Early on in the morning [Trent Lloyd][lathiat] presented his car tracker built
with a hobbyist GPS/GSM module and an Arduino programmed using a UML
methodology based on [state charts][uml-sc]. One of the nice things about this
talk is that it is related to [Harry McNally's talk last year][harry] about
using UML state charts for embedded programming.

[lathiat]: http://lathiat.net/
[uml-sc]: http://en.wikipedia.org/wiki/UML_state_chart
[harry]: /2009/statecharts-and-numbats/

Second was [Sam Spencer's][sam] fascinating introduction to the increasing use
of open source technologies within the [Australian Bureau of Statistics][abs].
He told us about the work currently underway at the ABS to provide their data
in more useful and open formats (XML-based standards) than the current mix of
PDF, Excel, and other proprietary documents. This was the highlight for me,
and a great opportunity to hear from someone working at the coal face.

[sam]: http://www.kidstrythisathome.com/
[abs]: http://abs.gov.au/

Also in the morning I saw Cristian Frichot talk about web application
security. His interesting overview of one or two classes of vulnerabilities
(including cross-site request forgery), some statistics (18% of phishing sites
are on hijacked servers; 26% of Australians were "affected" by identity fraud
in 2009), and references to efforts raising the profile and quality of web
application security were particularly timely for me. Of particular interest
were the [Open Web Application Security Project][owasp] and their open source
[Enterprise Security API][esapi] project.

[owasp]: http://www.owasp.org/
[esapi]: http://www.owasp.org/index.php/ESAPI

Matt Lambie spoke about Brazilian Jiu-Jitsu and the lessons he's learned from
it (he's a blue belt) and their application in business (he's the CEO of [the
Frontier Group][frontier]). This was an interesting talk (for the Jiu-Jitsu
demonstrations if no other reason) which seemed to emphasise the importance
good decision making (especially with respect to our own capabilities) and
agility.

[frontier]: http://thefrontiergroup.com.au/

A fascinating talk, if perhaps not "useful", was David Cake's overview of the
"sausage factory" that is ICANN and the DNS. He managed to cover a lot of
ground to give us a flavour of the acronym soup that is the ICANN and the
somewhat farcical (from the outside) nature of the procedures and politics at
play in the closest thing the Internet has to a governing body.

The last session of the afternoon was Adrian Chadd's talk about the
optimisation. Like many of the speakers, he covered a lot of ground pretty
quickly, but the take home message (the one *I* got) was that blithely
ignoring (or abstracting) many aspects of system and application performance
is coming back to bite us. Many of the performance challenges faced by
developers in decades past are making a resurgence and the industry (and
academia) seems ill prepared for them.
