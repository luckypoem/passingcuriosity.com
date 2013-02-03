---
layout      : post
title       : Making Laptops with Linux
categories  : [lca2011]
tags        : []
excerpt     : |
  Notes about making laptops work when running Linux.
---

Mattgew Garett, RedHat.

Laptops are great, but from a development point of view they are horrible
awful things.

What is a laptop? Scientists disagree. Kind of like a PC in a small box, with
a battery. Usually boot an unmodified OS (except Apple).

The primary thing that distinguished laptops from normal PCs is system
management modes (SMMs). While in SMM, it stops running your OS and starts
someone else's code which is entirely hidden from the OS. SMM works very well
so long as you act exactly like Windows. (Anecdote: HP laptop restoring
register state from CPU1 to CPU0, so the Linux ACPI interpreter always runs
events on CPU0.)

How do this become a problem
============================

Once upon a time we had Advanced Power Management (APM), advanced in the sense
that it's better than an on/off switch. APM was handled by the BIOS with no
significant control from the OS: you can do whatever you like, but you're
going to sleep afterward. Problems: BIOS control with a short, readable
specification.

ACPI provides a standardised interface to the firmware features so that the OS
can control such hardware features as:

- Fans

- Backlights: 

- Batteries: who thought it'd be a good idea for BIOS authors to workout how
  long your battery is going to last?

- IPMI devices:

Vendors want more and have put it all into ACPI, but they've all done it
differently:

- Hot keys (other than the sleep key)

- Radio control: RF kill, etc.

- Miscellaneous features: controlling screen features (transflexive mode),
  hard drive protection.

How do you work this out? ACPI and WMI.

ACPI code typically works in two ways:

- ACPU access triggers SMM
- ACPI access triggers an embedded controller

Embedded controllers are 8051-style microprocessor which runs its own code. It
can do approximately anything in response to anything. The embedded controller
is handled by the OS rather than the SMM BIOS stuff. But the OS needs a way to
find the methods and registers for the embedded controllers.

Method names: BTON - maybe something to do with Bluetooth.
EC names: BTPW - maybe something to do with Bluetooth.

See the LWN article about writing a driver for this stuff from about 18 months
ago.

It's not always so easy: Sony have found and exploited every loophole to make
a PC that doesn't act like any other PC.

Look in the ACPI tables for notify methods (which the firmware uses to notify
the OS of events): `Notify(SNC, Add (0x90, Local0))` in `SNNE()`, references
in `_Q0A` (`_Q` signifies an embedded controller interrupt). Need to get the
hot-key from the firmware and the register keeps changing.

But ACPI is too easy
====================

Microsoft, at some point, created a specification called [Windows Management
Instrumentation][WMI] and, at some point, decided to do their ACPI access
through WMI.

Most hardware is only tested under Windows, so the kernel tries to be as
Windows-y in dealing with hardware. Alternative to disassembling Windows (and
being sued): use QEmu, hacked to dump useful information, to run Windows and
Linux and check that they're doing the same thing in their ACPI interaction.

[WMI]: http://en.wikipedia.org/wiki/Windows_Management_Instrumentation
