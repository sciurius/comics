#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Sigmund;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Sigmund",
	  url     => "http://www.sigmund.nl/",
	  enabled => 1,
	  fetch   => "single",
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
