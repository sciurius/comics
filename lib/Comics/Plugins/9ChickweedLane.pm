#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::9ChickweedLane;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "9 Chickweed Lane",
	  url     => "http://www.comics.com/9_chickweed_lane",
	  enabled => 1,
	  fetch   => "gocomics",
	} );
}

# Important: Return the package name!
__PACKAGE__;
