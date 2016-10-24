#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Single;

=head1 NAME

Comics::Fetcher::Single -- Simple url grabber

=head1 SYNOPSIS

  package Comics::Plugin::Sigmund;
  use parent qw(Comics::Fetcher::Single);

  sub register {
      shift->SUPER::register
	( { name    => "Sigmund",
	    url     => "http://www.sigmund.nl/",
	    pat	  =>
	      qr{ <img \s+
		  src="?(?<url>strips/(?<image>sig.+\.\w+))"? \s+
		  width="\d+" \s+
		  height="\d+" \s+
		  border="\d+" \s* >
		}x,
	  } );
  }
  # Return the package name.
  __PACKAGE__;

=head1 DESCRIPTION

The C<Single> Fetcher requires registration of a pattern I<pat> that
is used to determine the URL of the desired image from the contents of
the comic's home page.

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

The pattern to locate the image URL. It should be as flexible as
possible, while still guaranteed to extract the correct image URL.

When the pattern matches, it must define at least the following named
captures:

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

=cut

use parent qw(Comics::Fetcher::Base);

our $VERSION = "0.01";

sub fetch {
    my ( $self ) = @_;
    my $state = $self->{state};
    my $pat = $self->{pat};
    my $name = $self->{name};
    my $ourl = $self->{url};
    delete $state->{fail};

    $::stats->{tally}++;
    $::stats->{fail}++;

    ::debug("(Single) Fetching index $ourl");
    my $res = $::ua->get($ourl);
    unless ( $res->is_success ) {
	$state->{fail} = $res->status_line;
	::debug("FAIL: ", $state->{fail});
	return;
    }

    my $data = $res->content;
    unless ( $data =~ $pat ) {
	$state->{fail} = "NOT FOUND";
	::debug("FAIL: (final) pattern not found");
	return;
    }

    # Match data expected:
    #
    # url (mandatory)
    # image (mandatory)
    # title
    # alt
    my $url   = $+{url};
    my $image = $+{image};
    my $title = $+{title};
    my $alt   = $+{alt};

    my $tag = $self->{tag};
    $alt ||= $tag;

    my $img = $image;
    $img =~ s/^.+(\.\w+)$/$tag$1/;

    $url = $self->urlabs( $ourl, $url );

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
