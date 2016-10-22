#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::LeastICouldDo;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

#### TODO: Need multiple fetcher...

sub register {

    # Current image is date formatted.
    my @tm = localtime($::ts);
    my $path = sprintf( "%04d/%02d/%04d%02d%02d.jpg",
			1900+$tm[5], 1+$tm[4],
			1900+$tm[5], 1+$tm[4], $tm[3] );

    shift->SUPER::register
      ( { name    => "Least I Could Do",
	  url     => "http://www.leasticoulddo.com/",
	  enabled => 1,
	  fetch   => "direct",
	  path	  => $path,
	} );
}

# Important: Return the package name!
__PACKAGE__;
