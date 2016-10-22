#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::CyanideAndHappiness;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Cyanide & Happiness (Explosm.net)",
	  url     => "http://explosm.net/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		id="featured-comic" \s+
		src="(?<url>//files.explosm.net/comics/
		(?:.+?/)?
		(?<image>[^./]+\.\w+))
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
