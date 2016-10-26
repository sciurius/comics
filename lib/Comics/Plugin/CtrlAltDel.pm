#! perl

use strict;
use warnings;

package Comics::Plugin::CtrlAltDel;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {

    shift->SUPER::register
      ( { name    => "CTRL+ALT+DEL",
	  url     => "http://www.cad-comic.com/cad/",
	  pat     =>
	    qr{ <a \s+ href="/" \s+ class="nav-next">Next</a>
		</div> \s*
		<img \s+
		 src="(?<url>http://.*?\.cad-comic\.com/comics/
		      (?<image>.*?\.\w+))" \s+
		 alt="(?<alt>.*?)" \s+
		 title="(?<title>.*?)"
	      }xs,
	} );
}

# Important: Return the package name!
__PACKAGE__;
