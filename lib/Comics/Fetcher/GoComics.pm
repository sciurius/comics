#! perl

use strict;
use warnings;

package Comics::Fetcher::GoComics;

use parent qw(Comics::Fetcher::Base);

use Comics::Fetcher::Single;

our $VERSION = "0.01";

sub fetch {
    my ( $self ) = @_;

    # Currently suboptiomal (image is a bit smaller).
    # Need a better method in the future.

    $self->{pat} =
      qr{ <img \s+
	  alt="(?<alt>[^"]+)" \s+
	  class="strip" \s+
	  src="(?<url>http://assets.amuniversal.com/
	    (?<image>[0-9a-f]+))"
        }x;
    Comics::Fetcher::Single::fetch($self);
}

1;
