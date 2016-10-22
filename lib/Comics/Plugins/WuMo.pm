#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::WuMo;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "WuMo",
	  url     => "http://wumo.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>/img/wumo/\d+/\d+/
		  (?<image>wumo.+?\.\w+))" \s+
	        alt="(?<alt>Wumo \s \d+\. \s \w+ \s \d+)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
