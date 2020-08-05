#! perl

use strict;
use warnings;

package Comics::Plugin::PoorlyDrawnLines;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.03";

our $name    = "Poorly Drawn Lines";
our $url     = "http://www.poorlydrawnlines.com/";

our $pattern =
  qr{ <div \s+ class="wp-block-image[^"]*"> \s*
      <figure \s+ class=".*?">
      <img \s+
       src="(?<url>https?://www.poorlydrawnlines.com/wp-content/uploads/
	      \d+/\d+/
	      (?<image>.+?\.\w+))"
    }x;

# Important: Return the package name!
__PACKAGE__;
