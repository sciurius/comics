#! perl

use strict;
use warnings;

package Comics::Plugin::Sigmund;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.02";

sub register {
    shift->SUPER::register
      ( { name    => "Sigmund",
	  url     => "http://www.sigmund.nl/",
	  pat	  =>
	    qr{ <img \s+
		src="?(?<url>strips/(?<image>sig.+\.\w+))"? \s+
		width="\d+" \s+
		height="\d+" \s+
		border="\d+" \s* >
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
