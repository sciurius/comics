#! perl

use strict;
use warnings;

package Comics::Plugin::ThatsLife;

# That's Life is on GoComics, but doesn't have small/large images.

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "That's Life";
our $url     = "http://www.gocomics.com/thats-life/";
our $pattern =
 	  qr{ <img \s+
	       alt="(?<alt>[^"]+)" \s+
	       class="strip" \s+
	       src="(?<url>http://assets.amuniversal.com/
	           (?<image>[0-9a-f]+))" \s+
	       width="\d+" \s*
	       />
            }x;

# Important: Return the package name!
__PACKAGE__;
