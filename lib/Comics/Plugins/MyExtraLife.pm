#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::MyExtraLife;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Extralife",
	  url     => "http://www.myextralife.com/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		class="comic" \s+
		src="(?<url>http://www.myextralife.com/wp-content/uploads/
		\d+/\d+/
		(?<image>[^./]+\.\w+))" \s+
	        alt="(?<alt>.*?)" \s+
	        title="(?<title>.*?)" \s+
		/>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
