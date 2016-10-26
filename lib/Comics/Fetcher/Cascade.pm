#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Cascade;

=head1 NAME

Comics::Fetcher::Single -- Cascading url grabber

=head1 SYNOPSIS

  package Comics::Plugin::Sigmund;
  use parent qw(Comics::Fetcher::Cascade);

  sub register {
      shift->SUPER::register
	( { name    => "Sigmund",
	    url     => "http://www.sigmund.nl/",
	    pats    => [ qr{ ... (?<url>...) ... },
	               qr{ ... (?<url>...) ... },
	               ...
	               qr{ ... (?<url>...) ... } ],
	  } );
  }
  # Return the package name.
  __PACKAGE__;

=head1 DESCRIPTION

The C<Cascading> Fetcher can use one or more patterns to determine the
URL of the desired image. If multiple patterns are supplied, each
pattern is applied to the fetched page and must define the url for the
next page as a named capture. The process is repeated, and the final
pattern has to provide the final url and image name.

The Fetcher requires the common arguments:

=over 8

=item name

The full name of this comic, e.g. "Fokke en Sukke".

=item url

The url of this comic's starting (i.e. home) page.

=back

Fetcher specific arguments:

This Fetcher requires either C<path> (direct URL fetch), C<pat>
(single fetch), or C<pats> (cascading fetch).

=over 8

=item path

The URL of the desired image.

If I<path> is not an absolute URL, it will be interpreted relative to
the I<url>.

=item pat

A pattern to locate the image URL from the starting page.

=item pats

An array ref with patterns to locate the image URL.

When a pattern matches, it must define the named capture C<url>, which
points to the page to be loaded and used for the next pattern.

=back

The final pattern may additionally define:

=over 8

=item title

The image title.

=item alt

The alternative text.

=back

=cut

use parent qw(Comics::Fetcher::Base);

our $VERSION = "0.01";


sub fetch {
    my ( $self ) = @_;
    my $state = $self->{state};
    my $pats  = $self->{pats} || $self->{pat};
    my $name  = $self->{name};
    my $url   = $self->{url};
    delete $state->{fail};

    my ( $image, $title, $alt ) = @_;

    if ( $self->{path} ) {
	$url = $self->urlabs( $url, $self->{path} );
    }
    else {
	my $pix = 0;
	my $data;
	$pats = [ $pats ] unless eval { @$pats };
	foreach my $pat ( @$pats ) {
	    $pix++;

	    ::debug("Fetching page $pix $url");
	    my $res = $::ua->get($url);
	    unless ( $res->is_success ) {
		$self->{fail} = "Not found", return if $self->{optional};
		die($res->status_line);
	    }

	    $data = $res->content;
	    unless ( $data =~ $pat ) {
		$self->{fail} = "No match", return if $self->{optional};
		die("FAIL: pattern $pix not found");
	    }

	    $url = $self->urlabs( $url, $+{url} );
	    unless ( $url ) {
		die("FAIL: pattern $pix not found");
	    }

	    # Other match data expected:
	    $title = $+{title};
	    $alt   = $+{alt};
	}

        unless ( $title ) {
	    $title = $1 if $data =~ /<title>(.*?)<\/title>/;
	    $title ||= $name;
	}
    }

    my $tag = $self->{tag};
    $alt ||= $tag;
    $title ||= $name;

    $state->{trying} = $url;
    ::debug("Fetching image $url");
    my $res = $::ua->get($url);
    unless ( $res->is_success ) {
	die("FAIL (image): ", $state->{fail});
    }

    my $data = $res->content;
    my $info;
    if ( !$data or !($info = Image::Info::image_info(\$data)) ) {
	die("FAIL: image no data");
    }

    my $md5 = Digest::MD5::md5_base64($data);
    if ( $state->{md5} and $state->{md5} eq $md5 ) {
	::debug("Fetching: Up to date $url");
	$::stats->{uptodate}++;
	return $state;
    }

    my $img = $tag . "." . $info->{file_ext};
    $self->{c_width}  = $info->{width};
    $self->{c_height} = $info->{height};

    $self->save_image( $img, \$data );

    $state->{update} = time;
    $state->{md5} = $md5;
    delete( $state->{trying} );

    $self->{c_alt} = $alt;
    $self->{c_title} = $title;
    $self->{c_img} = $img;

    my $html = "$tag.html";
    $self->save_html($html);

    $state->{url} = $url;

    return 1;
}

1;
