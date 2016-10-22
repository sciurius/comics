#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::WhatTheDuck;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "What the Duck",
	  url     => "http://www.whattheduck.net/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>http://\d+\.media\.tumblr\.com/
		[0-9a-f]{32}/
		(?<image>tumblr_.*?_1280\.\w+))" \s+
	        alt="(?<alt>WTD.*?)" \s+
		width="\d+" \s+
		height="\d+" \s*
		>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
