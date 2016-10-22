#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Buttersafe;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Buttersafe",
	  url     => "http://www.buttersafe.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>http://buttersafe.com/comics/
		(?<image>\d+-\d+-\d+-[^./]+\.\w+))" \s+
	        alt="(?<alt>.*?)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
