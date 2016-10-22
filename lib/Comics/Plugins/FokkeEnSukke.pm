#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::FokkeEnSukke;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Fokke en Sukke",
	  url     => "http://www.foksuk.nl/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>content/formfield_files/
		  (?<image>formcartoon_[^./]+\.\w+))" \s+
		width="\d+" \s+
		height="\d+" \s+
	        alt="(?<alt>.*?)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
