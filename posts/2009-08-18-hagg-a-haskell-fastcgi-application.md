---
wordpressid: 1977
layout: post
title: "HAgg: a Haskell FastCGI application (in development)"
wordpressurl: http://passingcuriosity.com/?p=1977
---
I've had just about as much of PHP as I can take. I distrust the language itself and most of the packages written in it and have finally had enough. Rather than throwing in the towel and taking up garbage collection as a profession, I'm going to migrating at least my personal sites to Haskell. 

Before I can do so, I need to get a firm handle on Haskell web development. I've tried this before but usually get lost in trying to build the perfect web application monad with configuration loading, database connection, error handling, etc. built in. Usually, I'm also trying to brush the cobwebs off my knowledge of Haskell at the same time, so it only lasts a few days before I get distracted by something shiny.

This time I'm using a much simpler project as a starting point: I'm writing a simple "life stream" -- an application which will aggregate a number of feeds and display the most recent entries from them -- as a FastCGI application. This post is a short introduction to my goal, the approach I'm taking, and the project's status.

<!--more-->

## What is a *life stream*?

"*Life stream*" is the rather unappetising name given to an application which aggregates the various feeds of a persons online activity -- their entire online life, if you will -- and produces a summary. A life stream is also usually a *live* stream in that it reflects changes in the source feeds relatively quickly.

## Why implement a life stream Haskell?

Implementing a life stream makes a good first project with which I can get to grips with Haskell web development precisely due to its function as a pure aggregator. I don't need authentication, or serialisation, or data storage, or any sort of interactive functionality. All I need to do is periodically download and parse some feeds (easy with the [download-curl](http://hackage.haskell.org/package/download-curl) and [feed](http://hackage.haskell.org/package/feed) packages) and produce a summary to keep in memory and, in as many threads as I choose to use, serve FastCGI requests using this summary.

Easy.

## Approach

As the previous sections makes clear, I'm taking a very simple approach here. The execution of the program will go something like this:

1. Load the list of feed URLs.

2. Spawn a feed loading thread to:

   1. Fetch the feeds.
   2. Prepare an in-memory "summary" of them.
   3. Put this summary into a shared variable.
   4. Sleep for a while.

3. Spawn a bunch of threads to handle FastCGI requests:

   1. Fetch the summary.
   2. Render the summary as HTML (or whatever).
   3. Serve it to the client.

I'm using [software transactional memory](http://haskell.org/haskellwiki/Software_transactional_memory) to mediate access to the shared data store (i.e. the variable pointing to the list of data) and leaving error handling to whatever happens to be the default.

There is a single concession to the realities of the FastCGI environment in this "architecture" (if this even merits the name). My first instinct was to load the feeds during initialisation before starting the FastCGI request loop. This, of course, is just asking for a slow feed to cause the FastCGI process manager to think we've failed to start and start throwing 500 errors around. Instead, we begin with an empty state ("render the summary" means fold the list of items into an HTML document) which will be filled in not too long after we start serving requests.

## The code

Given the simplicity of the approach described above, it's only right that the code is simple too. And, indeed, the code *is* simple. The entire application is only four modules:

1. `HAgg` -- the `main` function.
2. `HAgg.Config` -- the data types and configuration loading.
3. `HAgg.Fetcher` -- the feed processing and update thread.
4. `HAgg.Handler` -- the CGI request-handling code.

All up, its just 205 lines of code -- comments and white-space included -- and almost all of that is importing modules and plumbing values from one library function to another.

At the moment, it's extremely limited -- the feed URIs and update period are hard-coded, the "processing" is just pulling out the item title, the feed "merging" is just list concatenation, etc. -- but it does fetch feeds and does publish the "processed" data via FastCGI. 

All up, I'm very impressed with how easy it is to get something like this off the ground. Certainly it's no PHP with [SimplePie](http://simplepie.org/) but neither does it require a PHP interpreter (and the few dozen megs of RAM to run it in), or permanent storage for caching. The whole thing uses around 2MB of RAM with 20 request handling threads, the update thread, and the feed data in memory.

## Improvements

There are a number of ways in which I could improve *HAgg*. 

1. The most obvious is by recording the data in permanent storage (i.e. a database of some sort) and presenting a more complete record of my online activity.

2. Another improvement that suggests itself is by having a per-feed update schedule and by paying attention to feeds that specify an update period.

Further improvements might include an actual template system and actually attempting to handle and deal with errors.

## Conclusion

If you'd like to look at the code, it's all available at [github.com/thsutton/hagg/](http://github.com/thsutton/hagg/). As soon as it's ready, it'll be running on [thomas-sutton.id.au](http://thomas-sutton.id.au/).
