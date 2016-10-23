#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Single;

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
