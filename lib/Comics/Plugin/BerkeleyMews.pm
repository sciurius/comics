#! perl

use strict;
use warnings;

package Comics::Plugin::BerkeleyMews;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Berkeley Mews";
our $url     = "http://www.berkeleymews.com/";
our $pattern =
	    qr{ <div \s+ id="comic"> \s+
		<img \s+
		 src="(?<url>(?:https?:)?//www.berkeleymews.com/comics/
		       (?<image>\d+-\d+-\d+-.*?))"  \s+
		 alt="(?<alt>.*?)" \s+
		 title="(?<title>.*?)" \s+
		 />
	      }xs;

# Important: Return the package name!
__PACKAGE__;
