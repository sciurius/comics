#! perl

use strict;
use warnings;

package Comics::Plugin::CSectionComics;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "C-Section Comics",
	  url     => "http://www.csectioncomics.com/",
	  pat	  =>
	    qr{ <div \s+ id="comic"> \s+
		<img \s+
		 src="(?<url>http://cdn.csectioncomics.com/csectioncomics/
		             wp-content/uploads/\d+/\d+/
			     (?<image>.*?\.\w+))" \s+
		 alt="(?<alt>.*?)" \s+
		 title="(?<title>.*?)" \s*
		/> \s* </div>
	      }six,
	} );
}

# Important: Return the package name!
__PACKAGE__;
