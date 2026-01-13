#! perl

use strict;
use warnings;

package Comics::Plugin::LeastICouldDo;

use parent qw(Comics::Fetcher::Cascade);

our $VERSION = "1.05";

our $name    = "Least I Could Do";
our $url     = "https://www.leasticoulddo.com/";

my @tm    = localtime(time);
my $year  = sprintf("%04d", 1900+$tm[5]);
my $yr    = substr($year, 2);
my $month = sprintf("%02d", 1+$tm[4]);
my $day   = sprintf("%02d", $tm[3]);

our @patterns =
  ( qr{ (?<url>https?://(?:www.)?leasticoulddo.com/
	    wp-content/uploads/$year/$month/
	    (?<image>(?:beg|licd)\d+-[a-z]+${day}_${yr}_desktop-2048x.*?\.jpg))
      }six,
  );

# Important: Return the package name!
__PACKAGE__;
