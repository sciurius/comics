#! perl

use strict;
use warnings;

package Comics::Plugin::Bloop;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "JHall Bloop";
our $url     = "http://jhallcomics.com/bloop/";

our $pattern =
  qr{ <div \s+ .*? class="image-block-wrapper \s+ .*? > \s*
      <noscript>
      <img \s+
       src="(?<url>https?://static1.squarespace.com/static/
                   .*?/t/.*?/.*?/
		   (?<image>.+?\.\w+))"
    }sx;

# Important: Return the package name!
__PACKAGE__;
