---
---

Use SELinux to implement a process-level sandbox.

Existing: chroot, seccomp, ptrace, etc. all have various advantages and
problems.

New design : setuid sandbox (Evans/Tiennes) from Google for Chrome.

Many don't utilise MAC facilities (SELinux, Smack)

Typically based around restricting ambient authority: they're trying to
contain applications which have general purpose conditions.

Sandboxing with MAC
-------------------

Utilise MAC to enhance sandboxing. This doesn't bring anything too special,
but is more of a defence in depth.

Layered approach:

- Process-level (MMU)
- DAC (UID allocator, privsep)
- Namespaces / chroot
- MAC isolation policy (write a sandbox policy which isolates the process/s
  from the rest of the system as much as possible)

Reduce Ambient Authority
------------------------

Simplify the security situation by reducing ambient authority.

`wc foo.txt`: `wc` requires general read permission for the system and uses
this "ambient" authority to open the file.

`cat foo.txt | wc`: `cat` opens the file and passes an open file descriptor to
`wc`, bundling the object and authority together. Specific authority is
delegated and `wc` now needs no permissions to access the filesystem: just the
file descriptor it is given!

fd passing is conceptually simple for users and follows the standard UNIX use
conventions. *zero configruration* simple supplied policy which strongly
isolates sandboxed apps.

Security abstraction: simply run apps via a sandbox launcher. Kiosk mode,
sVirt etc are similar approaches.

Implementation with SELinux
---------------------------

New sandbox label added to policy

Has no general permissions, only those absolutely required to execute (like
load shared libraries)

`sandbox` launcher causes app to be executed with this label; I/O happens via
fd. Written in perl.

Unique MCS label assigned to each instance for MAC isolation (cf. UID
allocation - both could be used)

Sets up home and tmp directories; copies in specific files; cleans up at exit.

Basic Use
---------

`id -Z` outputs security label (with SELinux, etc,) (`c0.c1023` means labels 0
- 1023).

`sandbox id -Z` outputs a randomly created sandbox label thingo `c533,c903`.
The actual value doesn't matter so long as it's unique at the time. A broad
"deny almost all" MAC policy applies to all `sandbox_t` labels.