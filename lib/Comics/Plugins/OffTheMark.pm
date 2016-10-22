#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::OffTheMark;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Off the mark",
	  url     => "http://www.comics.com/off_the_mark",
	  enabled => 1,
	  fetch   => "gocomics",
	} );
}

# Important: Return the package name!
__PACKAGE__;
