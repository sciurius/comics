#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::SMBC;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Saturday Morning Breakfast Cereal",
	  url     => "http://www.smbc-comics.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
	        title="(?<title>.*?)" \s+
		src="(?<url>http://www.smbc-comics.com/comics/
		  (?<image>[^./]+\.\w+))" \s+
	        id="cc-comic" \s+
		border="\d+" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
