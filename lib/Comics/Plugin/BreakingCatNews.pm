#! perl

use strict;
use warnings;

package Comics::Plugin::BreakingCatNews;

use parent qw(Comics::Fetcher::GoComics);

our $VERSION = "1.00";

our $name    = "Breaking Cat News";
our $url     = "https://www.gocomics.com/breaking-cat-news";

# Important: Return the package name!
__PACKAGE__;
