---
---

Rusty Russell.

Introduction
------------

"I don't care what my child does, I just want them to be happy." What if they
grow up to be a Windows user.

Neither nature, nor nurture: a lack of both. Brainwash early, brainwash often.

C coding for babies? Can't type without fine motor control. Arcade control
board, identifiers on left, operators in the right.

Not algorithms, not C, not ruby: is she retarded?

Rethink the plan
----------------

Switch on/off the lights when the baby raises/lowers hands.

Obviously, the next step is to put IR LEDs on kids hands, use wiimote to track
LEDs. libcwiid already exists.

Child safety (this has killed children before); use Python.

**Mark I** Double layered mittens with an IR LED poking out. BAD: sensitive to
hand-size; hard-angle sensitive; kids love taking them off.

**Mark II** Use a bracelet 12mm wide velvet ribbon, five splayed LEDs on side,
battery sewn into bracelet; metal press studs to complete circuit and hold it
on. Distraction 1: craft, how hard could it be? Blanket stitch. Making
physical things is hard (subscribing to Make magazine is not the same thing).
BAD: craft, fixed size range.

**Mark III**: replace studs with velcro. Velcro can't hold a reliable contact
strongly enough.

**Mark IV**: abandon close-makes-contact; 4 wide-angle IR LEDs, switch to AAA
rechargeable (kids are stronger than you'd think!); scrunchie.

**Distraction 2**: 3 months after; meeting a girl.

**Mark V**: a second scrunchie one.

**Distraction 3**: Drums on Guitar Hero World Tour. Hacking `libcwiid` to
support the drum kit. Children are all about the eyes and high contrast: when
they bang on the drums eyes appear on the screen (steal them from xeyes) and
play sounds (http://wiki.laptop.org/go/Sound_samples).

The enemy ("ball"): if your child grows up using sporting equipment
regularly...

Time to simplify
----------------

LCA have accepted, Better get it done!

`hand.py` baby hand on the screen (Googled for baby hands...) Ball bounces off
hand with sound.

`smear.py` kids love smearing stuff almost as much as parents hate cleaning it
up.

Problem: Python is slow (who knew?)! Events are reported by the Wiimote about
10ms apart. You've got no chance of keeping up with it all. Pixel-perfect
intersection is slow (simplify smearing to 8x8 array of masks instead of pixel
perfect). Pointing with the wrong hand (uses the other hand, maybe tie the
free hand behind her back)!

**Distraction 5**: vandalised southern expressway sign with LED throwies.

**Distraction 6**: soldering 60 LEDs (Christmas tree) takes longer than you'd
think!

TV on ground, Wiimote facing, interact directly with the TV.

4 and 7 year olds. 4yo recognised that the LEDs did it. Kids get excited and
move too close.

Conclusions
-----------

Built robustly! Make it robust so that they can't chew a LED off.

Make it reliable or the ball will win! One sensor was easy to occlude (two
webcams with brightly coloured scrunchies would have been better).

Trivial: don't make it too complex or involved. Kids have a short attention
span!