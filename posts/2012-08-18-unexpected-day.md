import ctypes
import ctypes.util

# Open the SO
libpcap_name = ctypes.util.find_library('pcap')
libpcap = ctypes.CDLL(libpcap_name)

# Start capturing
errbuf = ctypes.create_string_buffer(256)
handle = libpcap.pcal_open_live("any", 65535, 0, 0, errbuf)

# Check the error
errbuf.value == 'socket: Operation not permitted'


# Add properties on the function
# .errcheck = function
# .argtypes = [...]
# .restype = ...

class c_timecal(ctypes.Structure):
  _fields = [
    ("tv_sec", ctypes.c_ulong),
    ("tv_usec", ctypes.c_ulong),
  ]

