#! perl

use strict;
use warnings;

package Comics::Plugin::OnTheFastrack;

use parent qw(Comics::Fetcher::Cascade);

our $VERSION = "1.01";

our $name    = "On The Fastrack";

my @tm    = localtime(time);
my $year  = sprintf("%04d", 1900+$tm[5]);
my $yr    = substr($year, 2);
my $month = sprintf("%02d", 1+$tm[4]);
my $day   = sprintf("%02d", $tm[3]);

our $url     = "https://www.comicskingdom.com/on-the-fastrack/$year-$month-$day";

our @patterns	  =
  ( qr{ <meta \s+
	property="og:image" \s+
	content="(?<url>https://wp.comicskingdom.com/comicskingdom-redesign-uploads-production/$year/$month/(?<image>[a-zA-Z0-9]+\.\w+))"
      }x,
 );

# Important: Return the package name!
__PACKAGE__;
