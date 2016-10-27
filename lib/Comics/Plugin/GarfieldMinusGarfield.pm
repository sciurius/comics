#! perl

use strict;
use warnings;

package Comics::Plugin::GarfieldMinusGarfield;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Garfield minus Garfield",
	  url     => "http://garfieldminusgarfield.net/",
	  pat     =>
	    qr{ <div \s+
		class="photo"> \s+
		<a \s+ href=".*?"> \s*
		<img \s+
		 src="(?<url>http://.*?\.media\.tumblr\.com/
		 [0-9a-f]+/
		 (?<image>.*?\.\w+))" \s+
	         alt=".*?"/> \s*
		 </a>
	      }six,
	} );
}

# Important: Return the package name!
__PACKAGE__;
