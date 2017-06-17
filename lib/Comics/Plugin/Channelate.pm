#! perl

use strict;
use warnings;

package Comics::Plugin::Channelate;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Channelate";
our $url     = "http://channelate.com/";

our $pattern =
  qr{ <div \s+ id="comic.*?" \s+ class="comicpane" > \s*
      <img \s+
       src="(?<url>http://www.channelate.com/comics/(?<image>.+?\.\w+))" \s+
       alt="(?<alt>.*?)" \s+
       title="(?<title>.*?)"
    }sx;

# Important: Return the package name!
__PACKAGE__;
