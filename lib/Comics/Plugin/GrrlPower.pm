#! perl

use strict;
use warnings;

package Comics::Plugin::GrrlPower;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Grll Power";
our $url     = "https://grrlpowercomic.com",
our $pattern =
  qr{ <div \s+ id="comic"> \s*
      <img \s+
       src="(?<url>
	     https://grrlpowercomic.com/wp-content/uploads/
	     \d+/\d+/
	     (?<image>.*?\.\w+))" \s+
       alt="(?<alt>.*?)" \s+
       title="(?<title>.*?)" \s+
    }isx;

# Important: Return the package name!
__PACKAGE__;
