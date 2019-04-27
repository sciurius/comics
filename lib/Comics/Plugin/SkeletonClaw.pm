#! perl

use strict;
use warnings;

package Comics::Plugin::SkeletonClaw;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "Skeleton Claw";
our $url     = "http://www.skeletonclaw.com/";
our $pattern =
	    qr{ <div \s+ class="photo-wrapper"> \s+
		<a \s+ href=".*?"> \s+
		<img \s+
		 src="(?<url>https?://\d+.media.tumblr.com/
		        .*?/(?<image>.*?\.\w+))" \s+
			alt="(?<alt>.*?)">
	      }xs;

# Important: Return the package name!
__PACKAGE__;
