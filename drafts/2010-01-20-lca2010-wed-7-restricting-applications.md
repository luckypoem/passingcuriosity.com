---
---

Lots of reasons to distrust application code. 

*Vulnerably repository* Even in legitimate software, a single mistake on the
part of the otherwise trustworthy developers may allow an attacker to hijack
it.

*Malware* The author intends for the software to act maliciously. How do you
know who to trust (and where the software).

This is a problem as security has previously been aimed at controlling
*users*, tacitly assuming that programs are acting (correctly) on behalf of
the users.

DAC/MAC/RBAC

Reactive approach: 

* Patch the vulnerable software and hope that everyone updates. 
* Scan for known malware.

But this doesn't defend against zero-day malware and vulnerabilities.

Application-oriented access control
-----------------------------------

Control what particular applications are allowed to do.

Previously:

- *Isolation* based on `chroot()`, jails, VMs, containers. This is inflexible
  though, and doesn't reflect the way we work with multiple programmes
  treating the same data.

- *Restriction* using AppArmor, SELinux, Systrace, TOMOYO, etc. which allow
  particular programs to exercise particular capabilities. This results in
  enormous, complex policies and configurations.

Part II - A new paradigm
------------------------

Functionality-based controls - grant permissions to applications based on the
functionality that needs to be used (role-based, for applications).

Functionality-Based Application Confinement access control [LSM] module.

Powerful abstractions which simplify policy development. Define policy based
on high-level goals. Encapsulate and abstract particulars.

Provides both discretionary (set by the user) and mandatory controls (set by
the administrator).

Uses a policy manager which guides users through the process of creating
policies. Policies can usually be created without using learning modes (though
this is available if required).

Analysed just over 100 programs and came up with some example/default
functionality descriptions and looking at automating specification.

Usability Study
---------------

39 participants each used SELinux, AppArmor, and FBAC-LSM. Created policies to
confine two programs: one legitimate (Opera?) and one malicious (a trojan
Tetris). Used System Usability Scale and a count of threats which were not
mitigated afterward.

**Usability**

SELinux < 35/100
AppArmor < 55/100
FBAC-LSM < 70/100

Which statistical analysis validates and confirms.

**Overall exposure of risk**

SELinus > 40/100
AppArmor ~ 30/100
FBAC-LSM < 15/100

Demonstration
-------------

Similar to the task in the study task: confine a "trojan" `ksirtet`. Game
takes a while to start while it's doing it's trojan-y stuff (which few/none of
the users noticed).

Graphical tool to create policy.

Detects GUI, default set of perms. 

Looks at it to suggest functionality (but we can choose as well). It thinks
it's a game or a network game.

Looks for per-user files, per-app libs, per-app configuration.

"Save games in directory" parameter (does this come from the set).

http://schreuders.org/FBAC-LSM/