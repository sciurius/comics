#! perl

use strict;
use warnings;

package Comics::Plugin::CatsCafe;

use parent qw(Comics::Fetcher::GoComics);

our $VERSION = "1.00";

our $name    = "Cats Cafe";
our $url     = "https://www.gocomics.com/cats-cafe";

# Important: Return the package name!
__PACKAGE__;
