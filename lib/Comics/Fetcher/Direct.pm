#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Direct;

use parent qw(Comics::Fetcher::Base);

our $VERSION = "0.01";

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
