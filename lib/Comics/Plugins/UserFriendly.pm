#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::UserFriendly;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

#### TODO: Should use multiple fetcher.

sub register {
    shift->SUPER::register
      ( { name    => "User Friendly",
	  url     => "http://ars.userfriendly.org",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		alt="Latest \s Strip" \s+
		height="\d+" \s+ width="\d+" \s+
		border=0 \s+
		src="(?<url>[^"]+/cartoons/archives/[^"]+/(?<image>[^.]+\.gif))"
	      }ix,
	 } );
}

# Important: Return the package name!
__PACKAGE__;
