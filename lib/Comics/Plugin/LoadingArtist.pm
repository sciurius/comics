#! perl

use strict;
use warnings;

package Comics::Plugin::LoadingArtist;

use parent qw(Comics::Fetcher::Cascade);

our $VERSION = "1.02";

our $name    = "Loading Artist";
our $url     = "http://www.loadingartist.com/comic/";

our @patterns =
  (
   qr{ </title> \s*
       <meta \s+ property="og:url" \s+ content="(?<url>.*?)" \s*/? >
   }sx,
   qr{ <meta \s+ property="og:title" \s+ content="(?<title>.*?)" \s*/?>
      .*?
      <div \s+ class="comic"> \s*
      <img \s+
       src="(?<url>(?:https?://(?:www\.)?loadingartist.com)?/wp-content/uploads/
            \d+/\d+/
            (?<image>.+?\.\w+))"
 }sx,
   );

# Important: Return the package name!
__PACKAGE__;
