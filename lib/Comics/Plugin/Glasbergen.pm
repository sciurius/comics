#! perl

use strict;
use warnings;

package Comics::Plugin::Glasbergen;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.05";

our $name    = "Glasbergen";
our $url     = "https://www.glasbergen.com";
our $pattern =
	    qr{ <img \s+
		 class=".*?size-full.*?" \s+
		 src="(?<url>https?://i2.wp.com/www.glasbergen.com/wp-content/
		     uploads/\d+/\d+/(?<image>.+?))\?
	      }x;

# Important: Return the package name!
__PACKAGE__;
