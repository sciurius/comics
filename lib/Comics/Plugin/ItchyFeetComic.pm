#! perl

use strict;
use warnings;

package Comics::Plugin::ItchyFeetComic;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

# Moved to TinyView.
our $disabled = 1;

our $name    = "Itchy Feet";
our $url     = "http://www.itchyfeetcomic.com/";
our $pattern =
	    qr{ <img \s+
		alt="(?<alt>.*?)" \s+
		src="(?<url>https://i.imgur.com/
		(?<image>[^./]+\.\w+))"
	      }x;

# Important: Return the package name!
__PACKAGE__;
