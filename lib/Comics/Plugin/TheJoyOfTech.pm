#! perl

use strict;
use warnings;

package Comics::Plugin::TheJoyOfTech;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.02";

sub register {
    shift->SUPER::register
      ( { name    => "The Joy of Tech",
	  url     => "http://www.joyoftech.com/joyoftech/",
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
