<?php

class Foo {
    public function __construct($name) {
        $this->name = $name;
    }

    public function emote() {
        print $this->name . " is emoting.\n";
    }
}

// Construct the objects
$o1 = new Foo("Foo one");
$o2 = new Foo("Foo two");

// Call the methods directly
$o1->emote();
$o2->emote();

// Call the methods by reference
$f = $o1->emote;
