#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Glasebergen;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Glasbergen",
	  url     => "http://www.glasbergen.com",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+ class="ngg-singlepic" \s+
		title="(?<title>.*?)" \s+
		alt="(?<alt>.*?)" \s+
		src="(?<url>http://www.glasbergen.com/wp-content/
		gallery/cartoons/(?<image>.+?))" \s* />
	      }x,
	 } );
}

# Important: Return the package name!
__PACKAGE__;
