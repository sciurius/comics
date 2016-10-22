#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::XKCD;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "XKCD",
	  url     => "http://www.xkcd.com",
	  enabled => 1,
	  fetch   => "single",
	  pat     =>
	    qr{ <img \s+
		src="(?<url>//imgs\.xkcd\.com/comics/
		(?<image>.*?\.png))" \s+
	        title="(?<title>.*?)" \s+
	        alt="(?<alt>.*?)" \s* />
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
