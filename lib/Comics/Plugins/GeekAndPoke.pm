#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::GeekAndPoke;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Geek&Poke",
	  url     => "http://geek-and-poke.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <noscript><img \s+
		src="(?<url>https://static1.squarespace.com/static/
		      [0-9a-f]+/t/[0-9a-f]+/
		      (?<image>[0-9a-f]+)/)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
