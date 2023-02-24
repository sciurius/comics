#! perl

use strict;
use warnings;

package Comics::Plugin::Claw;

use parent qw(Comics::Fetcher::GoComics);

our $VERSION = "1.00";

our $name    = "Claw";
our $url     = "https://www.gocomics.com/claw";

# Important: Return the package name!
__PACKAGE__;
