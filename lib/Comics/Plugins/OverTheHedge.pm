#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::OverTheHedge;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Over the hedge",
	  url     => "http://www.comics.com/over_the_hedge",
	  enabled => 1,
	  fetch   => "gocomics",
	} );
}

# Important: Return the package name!
__PACKAGE__;
