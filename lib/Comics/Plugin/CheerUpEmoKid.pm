#! perl

use strict;
use warnings;

package Comics::Plugin::CheerUpEmoKid;

use parent qw(Comics::Fetcher::GoComics);

our $VERSION = "1.01";

our $name    = "Cheer Up Emo Kid";
our $url     = "https://www.gocomics.com/cheer-up-emokid";

# Important: Return the package name!
__PACKAGE__;
