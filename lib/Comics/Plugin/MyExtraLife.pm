#! perl

use strict;
use warnings;

package Comics::Plugin::MyExtraLife;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Extralife";
our $url     = "http://www.myextralife.com/";
our $pattern =
	    qr{ </noscript> \s*
		<img \s+
		class="thumb-image" \s+
	        alt="(?<alt>.*?)" \s+
		data-src="(?<url>https?://static\d.squarespace.com/static/
		[0-9a-f]+/
		[0-9a-f]+/
		[0-9a-f]+/
		[0-9]+/
		(?<image>[^./]+\.\w+))"
	      }xi;

# Important: Return the package name!
__PACKAGE__;
