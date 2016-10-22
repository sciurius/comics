#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Sinfest;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Sinfest",
	  url     => "http://www.sinfest.net/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>btphp/comics/(?<image>\d+-\d+-\d+\.gif))" \s+
		alt="(?<alt>.*?)">
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
