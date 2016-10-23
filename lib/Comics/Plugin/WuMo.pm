#! perl

use strict;
use warnings;

package Comics::Plugin::WuMo;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.02";

sub register {
    shift->SUPER::register
      ( { name    => "WuMo",
	  url     => "http://wumo.com/",
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
