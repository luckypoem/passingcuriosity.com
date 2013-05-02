Tim Ansell talking about gstreamer in Python. He isn't part of the project or
any sort of expert.


Gstreamer is a multimedia framework with Python bindings. Follows the standard
UNIX philosophy but for multimedia content instead of text.

Pipeline of components:

	digraph pipeline {
		source -> demux;
		demux -> queue 1 -> audio decoder  -> audio sink;
		demux -> queue 2 -> video decoder -> video sink;
	}

Two tools:

- `gst-inspect` allows you to learn about the modules and components installed
  on your system.

- `gst-launch` allows you to build and run a pipeline on the command line.

Audio examples:

	# Get some audio from ... and play it  out your ALSA output.
    gst-launch ... ! audiconvert ! alsasink

    # Get some audio from ... and play it out whatever your system supports.
    gst-launch ... ! audiconvert ! autoaudiosink

    # Generate a test signal and send it to ...
    get-launch audiotestsrc ! ...

    # Play an Ogg Vorbis 
	gst-launch filesrc location=f.ogg
		oggdemux !
		vorbisdec !
		audioconvert !
		autoaudiosink

	# Use a module to detect formats and decode automatically
	gst-launch
		filesrc location=foo.mp3 !
		decodebin2 !
		audioconvert !
		...

Video formats are similar, but needs to fork for audio and video streams.

gstreamer uses glib and gobject libraries, so you need to use the Python
modules. Alas all of these modules lack docstrings.


The `dtmfdetect` component identifies DTMF tones in an audiostream and
produces events telling you the number.

Visualisation plugins (`goom`).

Effect plugins (distoring video streams prior to display on a perfect plasma;
maybe hipster them up a bit).

Analysis plugins (facedetect emits events with the position of faces detected
in the video stream).
