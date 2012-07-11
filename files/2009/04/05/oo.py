#!/usr/bin/env python
"""
This is a simple programme which demonstrates the use of references to methods
on objects in Python. This can be constrasted with the accompanying files
demonstrating similar techniques in Javascript, PHP, and Ruby.

For more information see the articles discussing this issue at:
    <http://passingcuriosity.com/2009/object-oriented-function-references>
"""

class Foo:
    def __init__(self, name):
        self.name = name

    def emote(self):
        print "%s is emoting" % self.name

if __name__ == "__main__":
    # Call the method directly 
    o1 = Foo("foo one")
    o2 = Foo("foo two")
    o1.emote()
    o2.emote()

    # Call the method by reference
    f = o1.emote
    f()
    f = o2.emote
    f()
