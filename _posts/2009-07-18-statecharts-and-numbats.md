--- 
wordpressid: 1312
wordpressurl: http://passingcuriosity.com/?p=1312
layout: post
title: Notes on "Statecharts and Numbats"
tags: [bcperth09]
categories: [barcamp]
location: Perth, Western Australia
excerpt: |
  This post consists of my notes on the Statecharts and Numbats presentation
  by Harry McNally at Perth Barcamp 3.0.
---

This post consists of my notes on the *Statecharts and Numbats* presentation
by Harry McNally at *Perth Barcamp 3.0*. As Harry notes in his
[comment](/2009/statecharts-and-numbats/#comment-144) below, his slides are
available online: [slides for Statecharts and Numbats
presentation](http://www.decisions-and-designs.com.au/harry/barcamp09.pdf).

Motivation
=======

Numbat: the emblem of WA. Last year became endangered. There are currently an estimated 1500 individuals in the wild divided between in two sites. The [Perth Zoo](http://www.perthzoo.wa.gov.au/) has [Numbat House](http://www.perthzoo.wa.gov.au/Animals--Plants/Australia/Australian-Bushwalk/Numbat/) and, behind scenes, breeding program which releases adult individuals into the wild populations. They eat termites: approximately 20,000 termites per day for adults.

[Project Numbat](http://www.numbat.org.au/) tries to help prevent their extinction. Tony Friend, research scientist based in Albany, works on numbats. Radio tracking in Dryandra Woodland. For two weeks every October, trapping, radio tagging, and monitoring their behaviour.

Setup video cameras pointed at logs housing numbats and use them to record their emergence, time, etc. each day. 24x7 for two weeks. This involves visiting every log each and every afternoon and evening to setup the cameras and every morning to collect them. To help reduce the large amounts of manual work involved in this monitoring programme, Harry aimed to create a device to automate the control of the cameras, allowing the placement and collection to be done much during the day rather than as close to the numbats' emergence as possible.

Storyboard
---------------

Step 1: Arrive at a log (with a numbat living in it) to set up the camera.

Step 2: Check the time and adjust the clock on the control device.

Step 3: Set start time for recording using the simple push-button controls.

Step 4: Test that start and stop both work and position the device. 

Step 5: Numbats! (Or videos of numbats!)


Technical Aspects
============

Platform
--------

Build own hardware with an LCD, push-buttons, IR module to send commands, micro-controller, etc. Alternatively, use a pre-built device like the AVR Butterfly which has it all built in.

Implementation
---------------------

Small efficient state machines for use in embedded devices w/ micro-controllers. Simplify the design and implementation of reactive, event-based systems. 

Hierarchical state machine. UML diagram which describes the system in terms of it's states and transitions together with the conditions for same. This can be used to generate an implementation.

http://state-machine.com/

Three tasks
---------------

1. UI task - handling the buttons, etc.
3. Alarm task - trigger alarms
3. IR transmit task - send IR messages to the camera

Each of them has an event queue:

1. Button driver queues events for the UI
2. UI sends events to alarm and/or IR tasks
3. Alarm task sends events to the IR task.

Generates `C` code: states become functions containing a `switch`, each possible input (from the appropriate event queue?) is a `case` which may use one of a number of macros to *handle*, *transition*, etc. as required. Each `switch` typically includes `case` *entry*, *exit*, and whatever custom events such as *timeouts* the state uses.

Unhandled events in a state bubble up to ancestors. If it gets to the top, the event is handled by the default "throw this event away" handler.

5192 bytes of program: `.text` + `.data.` + `.bootloader`.

Only 51 bytes of data used: `.data` + `.bss` + `.noinit`.
