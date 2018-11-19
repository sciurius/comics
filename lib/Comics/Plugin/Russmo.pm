#! perl

use strict;
use warnings;

package Comics::Plugin::Russmo;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Russmo";
our $url     = "http://russmo.com";
our $pattern =
	    qr{ <img \s+
		src="(?<url>https?://russmo.com/wp-content/
		uploads/\d+/\d+/(?<image>\d+.+?))" \s+
	        alt="" \s+
	        class="wp-image-627"
	      }x;

# Important: Return the package name!
__PACKAGE__;
