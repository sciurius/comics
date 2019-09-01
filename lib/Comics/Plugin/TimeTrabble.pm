#! perl

use strict;
use warnings;

package Comics::Plugin::TimeTrabble;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Time Trabble";
our $url     = "https://timetrabble.com/";
our $pattern =
	    qr{ <div \s+ id="comic-1" \s+ class="comicpane">
		<img \s+
		src="(?<url>(?:https?:)?//timetrabble.com/comics/
		       (?<image>.*?))"  \s+
		alt="(?<alt>[^"]+)" \s+
	      }x;

# Important: Return the package name!
__PACKAGE__;
