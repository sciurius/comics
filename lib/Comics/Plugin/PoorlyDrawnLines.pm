#! perl

use strict;
use warnings;

package Comics::Plugin::PoorlyDrawnLines;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.08";

our $name    = "Poorly Drawn Lines";
our $url     = "https://www.poorlydrawnlines.com/";

our $pattern =
  qr{ <figure \s+ class="wp-block-image[^"]*"> \s*
      <a \s* href=".*?">
      <img \s+ (?: (?:loading|width|height|decoding) = "[^"]+" \s+ )*
       src="(?<url>https://poorlydrawnlines.com/wp-content/uploads/
	      \d+/\d+/
	      (?<image>.+?\.\w+))"
    }x;

# Important: Return the package name!
__PACKAGE__;
