#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Dilbert;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Dilbert",
	  url     => "http://dilbert.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		class="img-responsive \s img-comic" \s+
		width="\d+" \s+
		height="\d+" \s+
		alt="(?<alt>[^"]+)" \s+
		src="(?<url>http://assets.amuniversal.com/
		       (?<image>.*?))"  \s+ />
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
