#! perl

use strict;
use warnings;

package Comics::Plugin::MeerBeterAlles;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

my @tm    = localtime(time);
my $year  = sprintf("%04d", 1900+$tm[5]);
my $yr    = substr($year, 2);
my $month = sprintf("%02d", 1+$tm[4]);
my $day   = sprintf("%02d", $tm[3]);

our $name    = "Meer Beter Alles";
our $url     = "https://meerbeteralles.nl/";
our $pattern =
  qr{ <template \s+ class="vp-portfolio__item-popup" \s*

      .*?

      "(?<url>https://.*?\.wp\.com/meerbeteralles\.nl/
	  wp-content/uploads/$year/$month/(?<image>.*?-scaled.jpg))

  }x;

# Important: Return the package name!
__PACKAGE__;
