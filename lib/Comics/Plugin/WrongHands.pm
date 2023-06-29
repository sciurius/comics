#! perl

use strict;
use warnings;

package Comics::Plugin::WrongHands;

use parent qw(Comics::Fetcher::GoComics);

our $VERSION = "1.00";

our $name    = "Wrong Hands";
our $url     = "https://www.gocomics.com/wrong-hands";

# Important: Return the package name!
__PACKAGE__;
