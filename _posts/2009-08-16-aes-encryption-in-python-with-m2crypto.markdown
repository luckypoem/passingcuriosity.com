--- 
wordpress_id: 1866
layout: post
title: AES encryption in Python with M2Crypto
wordpress_url: http://passingcuriosity.com/?p=1866
---
I've needed to write some Python code to handle encryption and decryption recently. This is a short post describing how I did it.

I'm interacting with a system which encrypts data in transit like so:

> The encryption algorithm is AES with a 16 bit [sic] key. The cipher mode is CBC with PKCS5 
> padding. The initialisation vector is 16 bytes of 00.

Thus I need to handle 128-bit AES in CBC mode, and padding according to PKCS5. In addition, the key and encrypted data is all base64 encoded.

<!--more-->

There are a number of cryptography packages for Python. The first I found was a blog post describing [PyCrypto](http://www.codekoala.com/blog/2009/aes-encryption-python-using-pycrypto/). My requirements include [PKCS5 padding](http://www.chilkatsoft.com/faq/PKCS5_Padding.html), which PyCrypto doesn't seem to do. It also has it's own implementations of the encryption algorithms. 

The padding algorithm seems pretty simple. If I understand correctly, it'd go something like this in Python:

<pre lang="python">
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
unpad = lambda s : s[0:-ord(s[-1])]
</pre>

But I've got better things to do than convince myself that I've implemented it correctly. 

Thankfully, there's another options: [Me Too Crypto](http://chandlerproject.org/Projects/MeTooCrypto). Unlike PyCrypto, M2Crypto is a Python wrapper around [OpenSSL](http://openssl.org/) which is nice, as my code will be running under [mod_wsgi](http://code.google.com/p/modwsgi/) embedded in Apache along with [mod_ssl](http://httpd.apache.org/docs/2.2/mod/mod_ssl.html).

Alas, it has rather poor documentation. The best guide to using it I've seen is the [test code](http://svn.osafoundation.org/m2crypto/trunk/tests/). I'm using the EVP interface, and found `test_AES()` in the [EVP tests](http://svn.osafoundation.org/m2crypto/trunk/tests/test_evp.py) invaluable.

Without further ado, the code:

<pre lang="python">
from base64 import b64encode, b64decode
from M2Crypto.EVP import Cipher

__all__ = ['encryptor', 'decryptor']

ENC=1
DEC=0

def build_cipher(key, iv, op=ENC):
    """"""""
    return Cipher(alg='aes_128_cbc', key=key, iv=iv, op=op)

def encryptor(key, iv=None):
    """"""
    # Decode the key and iv
    key = b64decode(key)
    if iv is None:
        iv = '\0' * 16
    else:
        iv = b64decode(iv)
   
   # Return the encryption function
    def encrypt(data):
        cipher = build_cipher(key, iv, ENC)
        v = cipher.update(data)
        v = v + cipher.final()
        del cipher
        v = b64encode(v)
        return v
    return encrypt

def decryptor(key, iv=None):
    """"""
    # Decode the key and iv
    key = b64decode(key)
    if iv is None:
        iv = '\0' * 16
    else:
        iv = b64decode(iv)

   # Return the decryption function
    def decrypt(data):
        data = b64decode(data)
        cipher = build_cipher(key, iv, DEC)
        v = cipher.update(data)
        v = v + cipher.final()
        del cipher
        return v
    return decrypt

</pre>
