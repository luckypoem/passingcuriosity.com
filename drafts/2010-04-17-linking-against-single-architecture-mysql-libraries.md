---
title    : Using official MySQL builds with Python
location : Perth, Western Australia
excerpt  :
  The official MySQL packages for OS X are single architecture. This post
  reminds me how to build the Python connector to link against these single
  architecture libraries.
---

Using the [official MySQL packages for Mac OS X][mysql-mac] can cause problems
on Mac OS X. In particular, the packages are only available for a single
architecture while setuptools and the rest of the infrastructure expect
libraries to support i386 and ppc architectures. When it comes time to link a
compiled extension against such libraries the build process errors out.

In short, install the x86 or ppc package and not the 64-bit versions unless
you feel like recompiling Python, the packages you use, and all the libraries
they link against.

Then the following should work (top install in a `virtualenv`; you can skip
that bit if you like).

{% highlight bash %}
# Create a new virtual environment
virtualenv --no-site-packages development
cd development
source bin/activate

# Install
cd MySQL-python-1.2.3c1/
ARCHFLAGS='-arch i386' python setup.py build
python setup.py install
cd ..

# Install other things...
easy_install django
easy_install M2Crypto
{% endhighlight %}

[mysql-mac]: http://dev.mysql.com/downloads/mysql/5.1.html#macosx-dmg