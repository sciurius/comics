#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::JoyOfTech;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "The Joy of Tech",
	  url     => "http://www.joyoftech.com/joyoftech/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>joyimages/
		  (?<image>[^./]+\.\w+))" \s+
	        alt="(?<alt>.*?)" \s+
		width="\d+" \s+
		height="\d+" \s+
		border="\d+" \s*
		>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
