#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::JesusAndMo;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Jesus and Mo",
	  url     => "http://www.jesusandmo.net/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>http://www.jesusandmo.net/wp-content/uploads/
		  (?<image>[^./]+\.\w+))" \s+
	        alt="(?<alt>.*?)" \s+
	        title="(?<title>.*?)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
