#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::Base;

our $VERSION = "0.02";

sub register {
    my ( $pkg, $init ) = @_;
    my $self = { %$init };
    bless $self, $pkg;
    $self->{tag} ||= $self->tag_from_name;
    return $self;
}

sub fetch {
    my ( $self, $state ) = @_;
    if ( $self->{fetch} eq "single" ) {
	$state = $self->_std_1( $state, $self->{pat} );
    }
    elsif ( $self->{fetch} eq "gocomics" ) {
	$state = $self->_std_1( $state,
	    qr{ <img \s+
		alt="(?<alt>[^"]+)" \s+
		class="strip" \s+
		src="(?<url>
	                http://assets.amuniversal.com/
			(?<image>[0-9a-f]+))"
	      }x,
	);
    }
    elsif ( $self->{fetch} eq "direct" ) {
	$state = $self->_direct( $state );
    }
    else {
	die( $self->{name}, ": Don't know how to fetch data\n" );
    }
    return $state;
}

sub html {
    my ( $self, $state ) = @_;
    my $w = $self->{c_width};
    my $h = $self->{c_height};
    if ( $w > 1024 ) {
	$w = 1024;
	$h *= $w/$self->{c_width};
    }
    join('',
	 qq{<table class="toontable" cellpadding="0" cellspacing="0">\n},
	 qq{<tr>},
	 qq{<td nowrap align="left" valign="top">},
	 qq{<b>$self->{name}</b><br>\n},
	 qq{<font size="-2">Last update: },
	 "".localtime($state->{update}),
	 qq{</font><br><br></td>\n},
	 qq{</tr><tr><td>\n},
	 qq{<a href="$self->{url}?$::uuid">},
	 qq{<img border="0" alt="$self->{c_alt}" title="$self->{c_title}" src="$self->{c_img}" width="$w" height="$h"></a>},
	 qq{</td></tr></table>\n},
	);
}

################ Subroutines ################

use File::Spec;

sub spoolfile {
    my ( $file ) = @_;
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

sub _std_1 {
    my ( $self, $state, $pat ) = @_;
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
	return $state;
    }

    my $data = $res->content;
    unless ( $data =~ $pat ) {
	$state->{fail} = "NOT FOUND";
	::debug("FAIL: (final) pattern not found");
	return $state;
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

    $url = _urlabs( $ourl, $url );

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
	return $state;
    }

    $data = $res->content;
    my $info;
    if ( !$data or !($info = image_info(\$data)) ) {
	$state->{fail} = "NO DATA";
	::debug("FAIL (image): ", $state->{fail});
	return $state;
    }
    $::stats->{fail}--;

    my $md5 = md5_base64($data);
    if ( $state->{md5} and $state->{md5} eq $md5 ) {
	::debug("(Single) Up to date $url");
	$::stats->{uptodate}++;
	return $state;
    }

    $img = $tag . "." . $info->{file_ext};
    $self->{c_width}  = $info->{width};
    $self->{c_height} = $info->{height};

    my $f = spoolfile($img);
    open( my $fd, ">:raw", $f );
    print $fd $data;
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");

    $state->{update} = time;
    $state->{md5} = $md5;
    delete( $state->{trying} );

    $self->{c_alt} = $alt;
    $self->{c_title} = $title;
    $self->{c_img} = $img;

    my $html = "$tag.html";
    $f = spoolfile($html);
    open( $fd, ">:utf8", $f );
    print $fd $self->html($state);
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");

    $state->{url} = $url;
    return $state;
}

sub _direct {
    my ( $self, $state ) = @_;
    my $url = $self->{url};
    my $path = _urlabs( $url, $self->{path} );
    delete $state->{fail};

    $::stats->{tally}++;
    $::stats->{fail}++;

    $state->{trying} = $url;

    ::debug("(Direct) Fetching image $url");
    my $res = $::ua->get($url);
    unless ( $res->is_success ) {
	$state->{fail} = $res->status_line;
	::debug("FAIL (image): ", $state->{fail});
	return $state;
    }

    my $data = $res->content;
    unless ( $data ) {
	$state->{fail} = "NO DATA";
	::debug("FAIL (image): ", $state->{fail});
	return $state;
    }
    $::stats->{fail}--;

    my $md5 = md5_base64($data);
    if ( $state->{md5} && $state->{md5} eq $md5 ) {
	::debug("(Direct) Up to date $url");
	$::stats->{uptodate}++;
	return $state;
    }

    my $img = $path;
    my $tag = $self->{tag};
    $img =~ s/^.*(\.\w+)$/$tag$1/;

    my $f = spoolfile($img);
    open( my $fd, ">:raw", $f );
    print $fd $data;
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");

    $state->{update} = time;
    $state->{md5} = $md5;
    delete( $state->{trying} );

    $self->{c_alt} = "";
    $self->{c_title} = "";
    $self->{c_img} = $img;

    my $html = "$tag.html";
    $f = spoolfile($html);
    open( $fd, ">:utf8", $f );
    print $fd $self->html($state);
    close($fd) or warn("$f: $!\n");
    ::debug("Wrote: $f");

    $state->{url} = $url;
    return $state;
}

sub _urlabs {
    my ( $url, $path ) = @_;
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

1;
