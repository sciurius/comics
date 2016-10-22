#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::KevinAndKell;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Kevin and Kell",
	  url     => "http://www.kevinandkell.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>/\d+/strips/(?<image>kk\d+.\w+))" \s+
		alt="(?<alt>Comic \s Strip)"
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
