#! perl

use strict;
use warnings;

package Comics::Plugin::SkeletonClaw;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.02";

our $name    = "Skeleton Claw";
our $url     = "https://www.skeletonclaw.com/";
our $pattern =
  qr{ data-big-photo="(?<url>https://64.media.tumblr.com/
	  [0-9a-f]+/
	  [-0-9a-f]+/
	  s1280x1920/
	  (?<image>[0-9a-f]+\.\w+))"
      \s*
  }xs;

# Important: Return the package name!
__PACKAGE__;
