#! perl

use strict;
use warnings;

package Comics::Plugin::SkeletonClaw;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.01";

our $name    = "Skeleton Claw";
our $url     = "https://www.skeletonclaw.com/";
our $pattern =
	    qr{ <div \s+ class="photo-wrapper-inner"> \s+
		<a \s+ href=".*?"> \s*
		<img \s+
		 class="u-photo" \s+
		 src="(?<url>https?://\d+.media.tumblr.com/
		     .*?/
		     .*?/
		     s1280x1920/
		     (?<image>.*?\.\w+))" \s+
			alt="(?<alt>.*?)">
	      }xs;

# Important: Return the package name!
__PACKAGE__;
