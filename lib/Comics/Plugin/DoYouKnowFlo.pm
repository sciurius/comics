#! perl

use strict;
use warnings;

package Comics::Plugin::DoYouKnowFlo;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {

    shift->SUPER::register
      ( { name    => "Do you know Flo?",
	  url     => "http://www.doyouknowflo.nl/",
	  pat     =>
	    qr{ <img \s+
		 class="alignright .*? size-full" \s+
		 src="(?<url>http://doyouknowflo.nl/
		        uploads/\d+/\d+/
			(?<image>.*?\.\w+))" \s+
		 alt="(?<alt>.*?)"
	      }sx,
	} );
}

# Important: Return the package name!
__PACKAGE__;
