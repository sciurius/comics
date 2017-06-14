#! perl

use strict;
use warnings;

package Comics::Plugin::CheerUpEmoKid;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Cheer Up Emo Kid";
our $url     = "http://www.cheerupemokid.com";

our $pattern =
  qr{ <div \s+ .*? id="comic" \s+ class=".*?"> \s*
      <img \s+
       src="(?<url>https?://www.cheerupemokid.com/wp-content/uploads/
            \d+/\d+/
            (?<image>.+?\.\w+))" \s+
       (?:title|alt)="(?<title>.*?)"
    }sx;

# Important: Return the package name!
__PACKAGE__;
