#! perl

use strict;
use warnings;

package Comics::Plugin::DayByDay;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Day By Day";
our $url     = "https://www.daybydaycartoon.com";
our $pattern =
  qr{ <div \s+ id="comic"> \s*
      <img \s+
       src="(?<url>
	     $url/wp-content/uploads/
	     \d+/\d+/
	     (?<image>.*?\.\w+))" \s+
       alt="(?<alt>.*?)" \s+
       title="(?<title>.*?)" \s+
    }isx;

# Important: Return the package name!
__PACKAGE__;
