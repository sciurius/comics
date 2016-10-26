#! perl

use strict;
use warnings;

package Comics::Plugin::MyJetpack;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.01";

sub register {

    shift->SUPER::register
      ( { name    => "You're all just jealous of my Jetpack",
	  url     => "http://myjetpack.tumblr.com/",
	  pat     =>
	    qr{ <img \s+
		 src="(?<url>http://.*?\.media\.tumblr\.com/
		 [0-9a-f]+/(?<image>.*?\.\w+))" \s+
		 alt="For\sthe\sGuardian.?" \s+ /></a>
	      }xs,
	} );
}

# Important: Return the package name!
__PACKAGE__;
