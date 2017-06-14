#! perl

use strict;
use warnings;

package Comics::Plugin::LoadingArtist;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Loading Artist";
our $url     = "http://www.loadingartist.com/latest/";

our $pattern =
  qr{ <meta \s+ property="og:title" \s+ content="(?<title>.*?)">
      .*?
      <div \s+ class="comic"> \s*
      <img \s+
       src="(?<url>https?://www.loadingartist.com/wp-content/uploads/
            \d+/\d+/
            (?<image>.+?\.\w+))"
    }sx;

# Important: Return the package name!
__PACKAGE__;
