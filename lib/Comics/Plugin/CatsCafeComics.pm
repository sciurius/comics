#! perl

use strict;
use warnings;

package Comics::Plugin::CatsCafeComics;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Cat's Cafe";
our $url     = "http://catscafecomics.com/";

our $pattern =
  qr{ <div \s+ class="post-thumbnail"> \s*
      <a \s+ href="https://catscafecomics.wordpress.com/.*?"> \s*
      <img \s+ width="\d+" \s+ height="\d+" \s+
       src="(?<url>https://catscafecomics.files.wordpress.com/
	    \d+/\d+/(?<image>.+?\.\w+))
    }sx;

# Important: Return the package name!
__PACKAGE__;
