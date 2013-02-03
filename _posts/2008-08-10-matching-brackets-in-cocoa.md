---
wordpressid: 194
wordpressurl: http://passingcuriosity.com/?p=96
layout: post
title: Matching Brackets in Cocoa
tags: cocoa, objective c
location: Perth, Western Australia
excerpt: |
  Once you've got a piece of code to check that a string uses correctly 
  matched brackets, hooking it up to widgets in Interface Builder is pretty
  simple.
---

My last post was a solution to [A Programming Job Interview Challenge #13 -
Brackets](http://www.dev102.com/2008/07/21/a-programming-job-interview-challenge-13-brackets/)
using Haskell. My Haskell solution basically defined a function that processed
the input string in `O(n)` time and returned `True` if it was valid and
`False` if it was not. This is good and useful and (I believe) idiomatic
Haskell, but almost completely trivial. In this post I'll describe a solution
to the same problem, this time in Objective-C as an `NSFormatter` sub-class
for use in a Cocoa program.

Unlike many object-oriented languages and frameworks, Objective-C and the
Cocoa framework do not encourage sub-classing to modify the behaviour of
existing classes and components. Instead, Cocoa is designed around patterns
like delegate and the like, according to which classes may "out source"
(*delegate*) parts of their behaviour to others. This helps to make the system
more flexible (we can change behaviour at runtime simply by delegating to an
object of a different class) and reduces the amount of code to be written
(less boiler plate) but can be confusing to beginners and has encouraged the
travesty that is the pollution of `NSObject` with stubs for informal protocol
after informal protocol.

One way in which Cocoa makes use of the delegate pattern is in the formatting
of strings for display in text boxes: rather than create a hierarchy of
`NSTextField` subclasses each of which formats and displays a particular type
of object (`NSNumberTextField`, `NSTelephoneNumberTextField`,
`NSCurrencyTextField`, `NSStringTextField`, `NSEmailAddressTextField`, *ad
infinitum*), Cocoa allows us to give each `NSTextField` a formatter object
that knows how to format it's objects. In this post, I'm going to describe
`PCBrackettedStringFormatter`: a formatter which will ensure that any field it
is added to will only commit strings with correctly nested brackets.

There are a number of `NSFormatter` methods which you can implement to achieve
various effects. The simplest and most essential methods in the API are
`stringForObjectValue:` and `getObjectValue:forString:errorDescription:`. The
former is called when the `NSTextField` is given a value to be displayed (and
edited) and returns the `NSString` to be displayed and edited by the user. The
latter method is the inverse: it is called when the text box needs to convert
an `NSString` back into an object that can be handed back to the application
logic after editing. Using these two methods, we can implement a simple
formatter which forces the input strings to contain only validly nested
brackets.

The rest of the `NSFormatter` interface is composed of two methods to
implement support for validation *during* editing. The compatibility method
`isPartialStringValid:newEditingString:errorDescription:` is called every time
the user presses a key whilst the editing cell has keyboard focus to determine
if the newly edited string is valid. The newer and more feature-full
`isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription:`
allows the formatter greater flexibility in evaluating and responding to the
editing.

Our first step in creating an `NSFormatter` subclass to check that brackets
are correctly matched is to write the code to do the checking. As Objective-C
is a superset of C this is incredibly tedious and requires more code than it
should. This is exactly the sort of code that should be put in a category, so
I'll do so. Note that I've elided the actual bracket matching as it isn't
particularly interesting and the tedium of processing strings in C-like
languages cannot be understated:

{% highlight objc %}
@implementation NSString (MatchBrackets)

- (BOOL)bracketsAreMatched {
	int i,j;
	NSArray *stack = [[NSMutableArray alloc] init];
	// ... Some of the most tedious string processing code in existence elided ...
	return YES;
}
@end
{% endhighlight %}

The first version of `PCMatchedBacketFormatter` will use
`stringForObjectValue:` and `getObjectValue:forString:errorDescription:` to
make sure that the user can only enter strings of validly nested brackets.

{% highlight objc %}
// -------- PCMatchBracketFormatter.h --------
@interface PCMatchBracketFormatter : NSFormatter
@end

// -------- PCMatchBracketFormatter.m --------
@implementation PCMatchBracketFormatter

// Assume that the application knows what it's doing and only gives us validly strings
- (NSString *)stringForObjectValue:(id)anObject {
	return anObject;
}

// Check that the edited string is validly nested
- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	if ([string bracketsAreMatched]) {
		(*anObject) = string;
		return YES;
	} else {
		if (error) {
			(*error) = [NSString stringWithFormat:@"\"%@\" contains incorrectly matched brackers", string];
		}
		return NO;
	}
}
@end
{% endhighlight %}

Now we can add a custom object instance in Interface Builder, set it's class
to `PCMatchBracketFormatter` and point the `formatter` outlet of, e.g., an
`NSTextField` to it and it'll only accept strings with correctly nested
brackets. This basic pattern can be used to wrap any predicate function as an
`NSFormatter` subclass. To make the problem a little more interesting and the
resulting user interface a little more friendly, we could extend our class to
support partial editing with
`isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription:`,but
that'll have to wait until I'm interested in `NSFormatter`'s again. For now,
my curiosity about them has passed.

The code in this post was typed into WordPress rather than XCode, and I'm new
to Cocoa and Objective-C, so I'm sure I've made a few mistakes. Comments and
corrections are welcome...

My next post will focus on multiple targets, private frameworks, and XCode
templates using [Matt Gemmell](http://mattgemmell.com/)'s
[SS_PrefsController](http://mattgemmell.com/source#ssprefscontroller) as an
example.
