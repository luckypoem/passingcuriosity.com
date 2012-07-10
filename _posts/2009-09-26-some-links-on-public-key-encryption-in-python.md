--- 
wordpressid: 2031
layout: post
title: Some links on public key encryption in Python
wordpressurl: http://passingcuriosity.com/?p=2031
---
This is the text of the first answer I've posted on [Stack Overflow](http://stackoverflow.com). You can see it in context [](http://stackoverflow.com/questions/1320671/how-to-encrypt-a-string-using-the-key/#1480380), but I've posted it here with *all* the links:

> My blog post (the [http://passingcuriosity.com/2009/aes-encryption-in-python-with-m2crypto/](http://passingcuriosity.com/2009/aes-encryption-in-python-with-m2crypto/) link in John Boker's answer) does AES -- a symmetric encryption algorithm -- using the M2Crypto. [M2Crypto](http://chandlerproject.org/Projects/MeTooCrypto) is a Python wrapper around OpenSSL. If the public key encryption algorithm you need to use is supported by M2Crypto, then you could very well use it to do your public key cryptography. The API is pretty much a straight translation of [OpenSSL's](http://openssl.org/docs/crypto/crypto.html#OVERVIEW) into Python, so the somewhat sketchy documentation shouldn't be too much of a problem.
> 
> I found the [M2Crypto test suite](http://svn.osafoundation.org/m2crypto/trunk/tests/) to be a useful example of using its API. In particular, the [RSA](http://svn.osafoundation.org/m2crypto/trunk/tests/test_rsa.py), [PGP](http://svn.osafoundation.org/m2crypto/trunk/tests/test_pgp.py), and [EVP](http://svn.osafoundation.org/m2crypto/trunk/tests/test_evp.py) tests will help you figure out how to set up and use the library. Do be aware that they are unit-tests, so it can be a little tricky to figure out exactly what code is necessary and what is an artefact of being a test.
