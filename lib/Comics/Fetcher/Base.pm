#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Fetcher::Base;

use parent qw(Comics::Plugin::Base);

our $VERSION = "0.02";

sub fetch {
    my ( $self ) = @_;
    die( ref($self), ": Method 'fetch' not defined\n" );
}

################ Subroutines ################

use File::Spec;

sub spoolfile {
    my ( $self, $file ) = @_;
    File::Spec->catfile( $::spooldir, $file );
}

use Digest::MD5 qw(md5_base64);

sub tag_from_name {
    my $self = shift;
    my $tag = lc($self->{name});
    $tag =~ s/\W//g;
    return $tag;
}

use Image::Info qw(image_info);

sub urlabs {
    my ( $self, $url, $path ) = @_;
    if ( $path =~ m;^/; ) {
	if ( $path =~ m;^//; ) {
	    $path = "http:" . $path;
	}
	else {
	    $path = $url . $path;
	}
    }
    elsif ( $path !~ m;^\w+://; ) {
	$path = $url . "/" . $path;
    }

    return $path;
}

sub save_image {
    my ( $self, $image, $data ) = @_;
    my $f = $self->spoolfile($image);
    open( my $fd, ">:raw", $f );
    print $fd $$data;
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");
}

sub save_html {
    my ( $self, $html ) = @_;
    my $f = $self->spoolfile($html);
    open( my $fd, ">:utf8", $f );
    print $fd $self->html;
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");
}

1;
