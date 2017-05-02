#! perl

use strict;
use warnings;

package Comics::Plugin::CtrlAltDel;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {

    shift->SUPER::register
      ( { name    => "CTRL+ALT+DEL",
	  url     => "http://www.cad-comic.com/",
	  pat     =>
	    qr{ <img \s+
		 class="comic-display" \s+
		 src="(?<url>http://(?:.*\.)?cad-comic\.com/
		       wp-content/uploads/\d+/\d+/
		      (?<image>.*?\.\w+))" \s+
	      }xs,
	} );
}

# Important: Return the package name!
__PACKAGE__;
