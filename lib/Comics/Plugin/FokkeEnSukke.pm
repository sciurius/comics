#! perl

use strict;
use warnings;

package Comics::Plugin::FokkeEnSukke;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name = "Fokke en Sukke";
our $url = "https://www.nrc.nl/fokke-sukke/";

# See TODO in Base.pm.

our $pattern =
  qr{ <picture \s+ class="dmt-featured-image__picture"> \s*
      <source \s+
      srcset=".*?
      (?<url>https://images.nrc.nl/.*?/
	  static.nrc.nl/images/gn4/stripped/(?<image>data[-0-9a-f]+\.\w+))
  }xs;

# Important: Return the package name!
__PACKAGE__;
