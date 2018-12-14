#! perl

use strict;
use warnings;

package Comics::Plugin::RandyOtter;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Randy Otter";
our $url     = "http://www.randyotter.com/";
our $pattern =
	    qr{ <span \s+ class='nothumb'> \s*
		<img \s+
		 src='(?<url>(?:https?:)?//www.randyotter.com/
		      files/gimgs/
		       (?<image>.*?))'
	      }x;

# Important: Return the package name!
__PACKAGE__;
