#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Garfield;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Garfield",
	  url     => "http://www.comics.com/garfield",
	  enabled => 1,
	  fetch   => "gocomics",
	} );
}

# Important: Return the package name!
__PACKAGE__;
