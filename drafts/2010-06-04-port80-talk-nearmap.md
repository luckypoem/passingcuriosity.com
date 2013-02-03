---
title    : Ben Last's Port 80 talk about NearMap
location : Perth, Western Australia 
excerpt  : |
  This month, Perth Port80 had a talk by Ben Last from NearMap about some of 
  the issues they face building a photo mapping web app.
---

Ben Last works for [NearMap][nearmap], a Perth-based company who make
high-resolution, up to date photo maps of the five major Australian capital
cities and assorted other areas. They routinely deal with huge amounts of data
and lots of requests and need to do so with low latency. Ben went through some
of statistics involved in their operation and some of the techniques they've
used to manage this sort of performance.

800 million new images (that's around 30 TB of data) every month. Around 7
billion images in total. Around 800 requests per second which must be served
within 50 milliseconds. Paying customers who'll be very angry indeed if
service is interrupted. With these volumes of data, doing anything is very
expensive; just moving the data will required weeks or months of read time.




[nearmap]: http://www.nearmap.com/ "PhotoMaps by NearMap"