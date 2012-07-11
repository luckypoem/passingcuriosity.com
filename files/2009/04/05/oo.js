/*
 * This is a simple programme which demonstrates the use of references to
 * methods on objects in Python. This can be constrasted with the accompanying
 * files demonstrating similar techniques in Javascript, PHP, and Ruby.
 *
 * For more information see the articles discussing this issue at:
 *   <http://passingcuriosity.com/2009/object-oriented-function-references>
 */

var Foo = function(name){
    this.name = name;
}

Foo.prototype = {
    emote: function() {
        print (this.name + " is emoting");
    },
    toString: function() {
        return ("Foo " + this.name);
    }
};

(function main(){
    // Create two objects
    o1 = new Foo("foo one");
    o2 = new Foo("foo two");

    // Call the method directly
    o1.emote();
    o2.emote();

    // Call the method by reference
    f = o1.emote;
    f();
    f = o2.emote;
    f();

    // Call the method by reference passing the object explicitly
    f.call(o1);
    f.call(o2);
})();
