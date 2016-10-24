#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Direct;

=head1 NAME

Comics::Fetcher::Direct -- Named url grabber

=head1 SYNOPSIS

  package Comics::Plugin::LeastICouldDo;
  use parent qw(Comics::Fetcher::Direct);

  sub register {
      # Current image is date formatted.
      my @tm = localtime(time);
      my $path = sprintf( "%s/%04d/%02d/%04d%02d%02d.jpg",
			  "wp-content/uploads",
			  1900+$tm[5], 1+$tm[4],
			  1900+$tm[5], 1+$tm[4], $tm[3] );
      shift->SUPER::register
	( { name    => "Least I Could Do",
	    url     => "http://www.leasticoulddo.com/",
	    path    => $path,
	  } );
  }
  # Return the package name.
  __PACKAGE__;

=head1 DESCRIPTION

The C<Direct> Fetcher requires registration of a I<path> that is the
URL of the desired image. This image will be fetched and saved.

The Fetcher requires the common arguments:

=over 8

=item name

The full name of this comic, e.g. "Least I Could Do".

=item url

The base url of this comic.

=back

Fetcher specific arguments:

=over 8

=item path

The URL of the desired image.

If I<path> is not an absolute URL, it will be interpreted relative to
the I<url>.

=back

=cut

use parent qw(Comics::Fetcher::Base);

our $VERSION = "0.02";

sub fetch {
    my ( $self ) = @_;
    my $state = $self->{state};
    my $url = $self->{url};
    my $path = $self->urlabs( $url, $self->{path} );
    delete $state->{fail};

    $::stats->{tally}++;
    $::stats->{fail}++;

    $state->{trying} = $url;

    ::debug("(Direct) Fetching image $path");
    my $res = $::ua->get($path);
    unless ( $res->is_success ) {
	$state->{fail} = $res->status_line;
	::debug("FAIL (image): ", $state->{fail});
	return;
    }

    my $data = $res->content;
    my $info;
    if ( !$data or !($info = Image::Info::image_info(\$data)) ) {
	$state->{fail} = "NO DATA";
	::debug("FAIL (image): ", $state->{fail});
	return;
    }
    $::stats->{fail}--;

    my $md5 = Digest::MD5::md5_base64($data);
    if ( $state->{md5} && $state->{md5} eq $md5 ) {
	::debug("(Direct) Up to date $url");
	$::stats->{uptodate}++;
	return;
    }

    my $img = $path;
    my $tag = $self->{tag};

    $img = $tag . "." . $info->{file_ext};
    $self->{c_width}  = $info->{width};
    $self->{c_height} = $info->{height};

    $self->save_image( $img, \$data );

    $state->{update} = time;
    $state->{md5} = $md5;

    delete( $state->{trying} );

    $self->{c_alt} = "";
    $self->{c_title} = "";
    $self->{c_img} = $img;

    my $html = "$tag.html";
    $self->save_html($html);

    $state->{url} = $url;

    return 1;
}

1;
