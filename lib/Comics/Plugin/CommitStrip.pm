#! perl

use strict;
use warnings;

package Comics::Plugin::CommitStrip;

use parent qw(Comics::Fetcher::Cascade);

our $VERSION = "1.01";

our $name     = "CommitStrip";
our $url      = "https://www.commitstrip.com/";
our @patterns =
	  ( qr{ <a \s+
		 href="(?<url>https://www.commitstrip.com/
		     \d\d\d\d / \d\d / \d\d / .*? /)">
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
	  );

# Important: Return the package name!
__PACKAGE__;
