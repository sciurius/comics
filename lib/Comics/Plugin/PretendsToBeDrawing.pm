#! perl

use strict;
use warnings;

package Comics::Plugin::PretendsToBeDrawing;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Pretends To Be Drawing";
our $url     = "http://ptbd.jwels.berlin/";

our $pattern =
  qr{ <div \s+ class="comicwrapper" .*? > \s+
      <img \s+
       alt="(?<alt>.*?)" \s+
       title="(?<title>.*?)" \s+
       class="comic" \s+
       itemprop="image" \s+
       src="(?<url>/comicfiles/full/(?<image>.+?\.\w+))"
    }sx;

# Important: Return the package name!
__PACKAGE__;
