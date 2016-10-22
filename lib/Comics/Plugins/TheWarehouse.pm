#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::TheWarehouse;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "The Warehouse",
	  url     => "http://www.warehousecomic.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>http://warehousecomic.com/wp-content/uploads/
		      (?<image>\d+/\d+/\d+-\d+-\d+-.*?\.\w+))" \s+
		alt="(?<alt>.*?)" \s+
		title="(?<title>.*?)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
