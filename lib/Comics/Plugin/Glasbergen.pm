#! perl

use strict;
use warnings;

package Comics::Plugin::Glasebergen;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.02";

sub register {
    shift->SUPER::register
      ( { name    => "Glasbergen",
	  url     => "http://www.glasbergen.com",
	  pat	  =>
	    qr{ <img \s+ class="ngg-singlepic" \s+
		title="(?<title>.*?)" \s+
		alt="(?<alt>.*?)" \s+
		src="(?<url>http://www.glasbergen.com/wp-content/
		gallery/cartoons/(?<image>.+?))" \s* />
	      }x,
	 } );
}

# Important: Return the package name!
__PACKAGE__;
