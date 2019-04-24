#! perl

use strict;
use warnings;

package Comics::Plugin::TheOtherEnd;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "The Other End";
our $url     = "http://www.theotherendcomics.com/";
our $pattern =
	    qr{ <div \s+ id="comic"> \s+
		<img \s+
		 src="(?<url>(?:https?:)?//www.kohney.com/
		       wp-content/uploads/\d+/\d+/
		       (?<image>.*?))"  \s+
		 alt="(?<alt>.*?)" \s+
		 title="(?<title>.*?)" \s+
		 />
	      }xs;

# Important: Return the package name!
__PACKAGE__;
