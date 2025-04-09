#! perl

use strict;
use warnings;

package Comics::Plugin::Lectrr;

# Note that lectrr yields random, watermarked images.

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.02";

our $name    = "Lectrr";
our $url     = "https://www.lectrr.be/nl/";
our $pattern =
	    qr{ <img \s+ class="s-img" \s+
		src="(?<url>https://upcdn.io/kW15boo/watermark/cartoonsearch/
		    (?<image>.*?\.\w+))" \s+
		alt="(?<title>.*?)"
	      }six;

# Important: Return the package name!
__PACKAGE__;
