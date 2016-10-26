#! perl

use strict;
use warnings;

package Comics::Fetcher::GoComics;

use parent qw(Comics::Fetcher::Cascade);

=head1 NAME

Comics::Fetcher::GoComics -- Fetcher for GoComics.

=head1 SYNOPSIS

  package Comics::Plugin::Garfield;
  use parent qw(Comics::Fetcher::GoComics);

  sub register {
      shift->SUPER::register
	( { name    => "Garfield",
	    url     => "http://www.comics.com/garfield",
	  } );
  }
  # Return the package name.
  __PACKAGE__;

=head1 DESCRIPTION

The C<GoComics> Fetcher handles comics that are on the GoComics
websites (comics.com, gocomics.com).

The Fetcher requires the common arguments:

=over 8

=item name

The full name of this comic, e.g. "Garfield".

=item url

The base url of this comic.

=back

Fetcher specific arguments:

=over 8

=item None as yet.

=back

=cut

our $VERSION = "0.03";

sub register {
    my ( $pkg, $init ) = @_;

    # Add the standard pattern for GoComics comics.
    $init->{pat} =
      qr{ <img \s+
	  alt="(?<alt>[^"]+)" \s+
	  class="strip" \s+
	  src="(?<url>http://assets.amuniversal.com/
	    (?<image>[0-9a-f]+))" \s+
          /></div>
        }x;

    # Leave the rest to SUPER.
    $pkg->SUPER::register($init);
}

1;
