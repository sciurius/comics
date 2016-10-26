#! perl

use strict;
use warnings;

package Comics::Plugin::CommitStrip;

use parent qw(Comics::Fetcher::Cascade);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "CommitStrip",
	  url     => "http://www.commitstrip.com/en/",
	  pat     =>
	  [ qr{ <meta \s+
		property="og:url" \s+
		content="(?<url>.*?)"/>
	      }x,
	    qr{ <img \s+
		src="(?<url>https://www.commitstrip.com/wp-content/uploads/
		       \d+/\d+/
		       (?<image>.*?\.\w+))" \s+
		alt="(?<alt>.*?)" \s+
		width="\d+" \s+
		height="\d+" \s+
		class="alignnone \s+ size-full.*?" \s+ />
	      }x
	  ],
	} );
}

# Important: Return the package name!
__PACKAGE__;
