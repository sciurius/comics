#! perl

use strict;
use warnings;

package Comics::Plugin::LeastICouldDo;

use parent qw(Comics::Fetcher::Direct);

our $VERSION = "0.02";

#### TODO: Need multiple fetcher...

sub register {

    # Current image is date formatted.
    my @tm = localtime(time);
    my $path = sprintf( "%s/%04d/%02d/%04d%02d%02d.jpg",
			"wp-content/uploads",
			1900+$tm[5], 1+$tm[4],
			1900+$tm[5], 1+$tm[4], $tm[3] );

    shift->SUPER::register
      ( { name    => "Least I Could Do",
	  url     => "http://www.leasticoulddo.com/",
	  path	  => $path,
	} );
}

# Important: Return the package name!
__PACKAGE__;
