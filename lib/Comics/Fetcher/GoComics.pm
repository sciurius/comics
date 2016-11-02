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

our $VERSION = "0.05";

sub register {
    my ( $pkg, $init ) = @_;

    # Leave the rest to SUPER.
    my $self = $pkg->SUPER::register($init);

    if ( ! $self->{url} && $self->{tag} ) {
	$self->{url} = "http://www.gocomics.com/" . $self->{tag} . "/";
    }

    # Add the standard pattern for GoComics comics.
    $self->{pattern} =
      qr{ <img \s+
	  alt="(?<alt>[^"]+)" \s+
	  class="strip" \s+
	  src="(?<url>http://assets.amuniversal.com/
	    (?<image>[0-9a-f]+))" \s+
          /></div>
        }x;

    return $self;
}

1;
