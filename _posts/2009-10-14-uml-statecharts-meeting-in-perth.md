--- 
wordpressid: 2038
wordpressurl: http://passingcuriosity.com/?p=2038
layout: post
title: UML Statecharts meeting in Perth
---

Last night I went to my second (or third, does the first "yes, we should" meeting count?) meeting of the [Perth UML State Charts reading group][1]. Curtin University is a bit of a trek for me (two busses out and three busses back; each trip takes around an hour), but at least I didn't wind up walking after getting off half way there! Unlike the first meeting (which was primarily about the book), we spent most of *this* meeting talking about projects and interesting things that we've seen around. What follows is in no particular order, and just a taste of the discussions (hooray for a poor memory).

I'd just installed the [Arduino][2], so I got that up on the projector for those who hadn't seen it before and talked a little bit about the goals of the Arduino project and how that has affected the implementation. Talking about the libraries and the "shield" approach helped solidify it in my mind a little and it's an interesting approach to this sort of development that seems new to some of the others (who're familiar with *real* embedded development). I also explained a few things about Haskell and the approach (as I understand it; i.e. "poorly") used in the [atom][3] library. I'm planning to have some more to say (*show*!) about using Haskell to implement hierarchical state-machines next fortnight.

Harry spoke about his numbatcam project (which he also [talked about at Perth Barcamp 2009][4]) in a bit more details and showed us some of the code. He mentioned the idea of reducing the duplication of states (one of the reasons we use *hierarchical* state-machines is to reduce the state explosion inherent in other state-machine formalisms) involved in his handling of setting the current time and the alarm time (each is an arrangement of a few states and transitions which are identical, other than their differing parent states).

I suggested that it would be possible, in a framework which supports orthogonal state-machines (multiple machines which run concurrently and independently of one another), to implement a "time chooser" state-machine and replace the current duplication with `waitingToSetTime` and `waitingToSetAlarm` states which have an entry action (posting a `SET_TIME(curr)` event) and a single transition on `TIME_SET(new)` events. Given that the UI state-machine is can be in either the `waitingToSetTime` or the `waitingToSetAlarm` states, then the "time chooser" state-machine can handle the entire choose-a-time interaction and then post the `TIME_SET(new)` event to the UI state-machine and whichever state it's currently in can set the time or the alarm as it wishes. Alas, the framework used in the numbatcam doesn't support orthogonal state-machines (easily).

Russell spoke about the doorbell system he'd been working on as a learning exercise. Rather than just play a sound every time the button is pressed, Russell's doorbell incorporates a "polite pause" a light and a buzzer (to deal with those annoy people who feel the need to press the button repeatedly). Though just a learning exercise, it was certainly an interesting one. Even more interesting was his hierarchical state-machine-based hierarchical state-machine generator! Based on a description of a hierarchical state-machine description in emacs outline format (plus some support code), his project will generate the C code implementing the state-machine. Even more impressive, it's implemented in exactly the same framework as the programs it generates. The only way he can make it more awesome would be to treat the current version as a bootstrap, and generate the next version from a state-machine description (to "eat his own dog food" so to speak).

In any case, there's lots of interesting stuff going on in the group. I'm looking forward to the next meeting.

[1]: http://groups.google.com/group/statechartsperth
[2]: http://www.arduino.cc/
[3]: http://hackage.haskell.org/package/atom
[4]: /2009/statecharts-and-numbats/
