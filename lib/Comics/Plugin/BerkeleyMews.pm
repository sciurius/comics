#! perl

use strict;
use warnings;

package Comics::Plugin::BerkeleyMews;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Berkeley Mews";
our $url     = "https://www.berkeleymews.com/";
our $pattern =
	    qr{ 
		<img \s+ decoding="async" \s+ loading="lazy" \s+
		src="(?<url>(?:https?:)?//www.berkeleymews.com/wp-content/
		    uploads/\d+/\d+/
		       (?<image>.*?))"  \s+
		 alt="(?<alt>.*?)" \s+

	      }xs;

# Important: Return the package name!
__PACKAGE__;
