#! perl

use strict;
use warnings;

package Comics::Plugin::CSectionComics;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.03";

our $name    = "C-Section Comics";
our $url     = "http://www.csectioncomics.com/";
our $pattern =
  qr{ <div \s+ id="comic"> \s+
      <img \s+
       src="(?<url>http://.*?.csectioncomics.com/csectioncomics/
                   wp-content/uploads/\d+/\d+/
                   (?<image>.*?\.\w+))" \s+
       alt="(?<alt>.*?)" \s+
       title="(?<title>.*?)" \s*
      />
    }six;

# Important: Return the package name!
__PACKAGE__;
