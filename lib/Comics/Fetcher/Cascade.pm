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
	    pat	  => [ qr{ ... (?<url>...) ... },
	               qr{ ... (?<url>...) ... },
	               ... ,
	               qr{ ... (?<url>...(?<image>...)) ... } ],
	  } );
  }
  # Return the package name.
  __PACKAGE__;

=head1 DESCRIPTION

The C<Cascading> Fetcher requires registration of an array I<pat> of
patterns that are used, one by one, to determine the URL of the
desired image. Each pattern must match to the url for the next
pattern, and the final pattern has to provide the final url and image
name.

The Fetcher requires the common arguments:

=over 8

=item name

The full name of this comic, e.g. "Fokke en Sukke".

=item url

The url of this comic's home page.

=back

Fetcher specific arguments:

=over 8

=item pat

An array ref with patterns to locate the image URL.

When a pattern matches, it must define the named capture C<url>, which
points to the page to be loaded and used for the next pattern.

The final pattern has to define:

=over 8

=item url

The (relative) url of the image.

If the URL is not an absolute URL, it will be interpreted relative to
the I<url> argument.

=item image

The image name within the url.

=item title

Optional. The image title.

=item alt

Optional. The alternative text.

=back

=back

As a special case, C<pat> may point to a pattern in which case the
Cascade Fetcher behaves identical to the Single Fetcher. In fact,
the Single Fetcher is a dummy wrapper around the Cascade Fetcher.

=cut

use parent qw(Comics::Fetcher::Base);

our $VERSION = "0.01";


sub fetch {
    my ( $self ) = @_;
    my $state = $self->{state};
    my $pat = $self->{pat};
    my $name = $self->{name};
    my $url = $self->{url};
    delete $state->{fail};

    $::stats->{tally}++;
    $::stats->{fail}++;

    my @pats;
    if ( ref($pat) eq 'ARRAY' ) {
	@pats = @$pat;
	$pat = pop(@pats);
    }

    my $pix = 0;
    while ( @pats ) {
	my $pat = shift(@pats);
	$pix++;

	::debug("(Single) Fetching page $pix $url");
	my $res = $::ua->get($url);
	unless ( $res->is_success ) {
	    $state->{fail} = $res->status_line;
	    ::debug("FAIL: ", $state->{fail});
	    return;
	}

	my $data = $res->content;
	unless ( $data =~ $pat ) {
	    $state->{fail} = "NOT FOUND $pix";
	    ::debug("FAIL: pattern $pix not found");
	    return;
	}

	$url   = $self->urlabs( $url, $+{url} );
	unless ( $url ) {
	    $state->{fail} = "NOT FOUND $pix";
	    ::debug("FAIL: pattern $pix not found");
	    return;
	}
    }

    $pix++;
    ::debug("(Single) Fetching page $pix $url");
    my $res = $::ua->get($url);
    unless ( $res->is_success ) {
	$state->{fail} = $res->status_line;
	::debug("FAIL: ", $state->{fail});
	return;
    }

    my $data = $res->content;
    unless ( $data =~ $pat ) {
	$state->{fail} = "NOT FOUND $pix";
	::debug("FAIL: pattern $pix (final) not found");
	return;
    }

    # Match data expected:
    #
    # url (mandatory)
    # image (mandatory)
    # title
    # alt
    $url   = $self->urlabs( $url, $+{url} );
    my $image = $+{image};
    my $title = $+{title};
    my $alt   = $+{alt};

    my $tag = $self->{tag};
    $alt ||= $tag;

    my $img = $image;
    $img =~ s/^.+(\.\w+)$/$tag$1/;

    unless ( $title ) {
	$title = $1 if $data =~ /<title>(.*?)<\/title>/;
	$title ||= $name;
    }

    $state->{trying} = $url;
    ::debug("(Single) Fetching image $url");
    $res = $::ua->get($url);
    unless ( $res->is_success ) {
	$state->{fail} = $res->status_line;
	::debug("FAIL (image): ", $state->{fail});
	return;
    }

    $data = $res->content;
    my $info;
    if ( !$data or !($info = Image::Info::image_info(\$data)) ) {
	$state->{fail} = "NO DATA";
	::debug("FAIL (image): ", $state->{fail});
	return;
    }
    $::stats->{fail}--;

    my $md5 = Digest::MD5::md5_base64($data);
    if ( $state->{md5} and $state->{md5} eq $md5 ) {
	::debug("(Single) Up to date $url");
	$::stats->{uptodate}++;
	return $state;
    }

    $img = $tag . "." . $info->{file_ext};
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
