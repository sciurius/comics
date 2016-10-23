#! perl

use strict;
use warnings;

package Comics::Plugin::Base;

our $VERSION = "0.03";

sub register {
    my ( $pkg, $init ) = @_;
    my $self = { %$init };
    bless $self, $pkg;
    $self->{tag} ||= $self->tag_from_name;
    return $self;
}

sub html {
    my ( $self ) = @_;
    my $state = $self->{state};

    my $w = $self->{c_width};
    my $h = $self->{c_height};
    if ( $h && $w ) {
	if ( $w > 1024 ) {
	    $w = 1024;
	    $h = int( $h * $w/$self->{c_width} );
	}
    }

    my $res =
	 qq{<table class="toontable" cellpadding="0" cellspacing="0">\n} .
	 qq{  <tr><td nowrap align="left" valign="top">} .
	 qq{<b>} . _html($self->{name}) . qq{</b><br>\n} .
	 qq{        <font size="-2">Last update: } .
	 localtime($state->{update}) .
	 qq{</font><br><br></td>\n} .
	 qq{  </tr>\n  <tr><td><a href="$self->{url}?$::uuid">} .
	 qq{<img border="0" };

    $res .= qq{alt="} . _html($self->{c_alt}) . qq{" }
      if $self->{c_alt};
    $res .= qq{title="} . _html($self->{c_title}) . qq{" }
      if $self->{c_title};
    $res .= qq{width="$w" height="$h" }
      if $w && $h;

    $res .= qq{src="$self->{c_img}"></a></td>\n  </tr>\n</table>\n};

    return $res;
}

sub _html {
    my ( $t ) = @_;

    $t =~ s/&/&amp;/g;
    $t =~ s/</&lt;/g;
    $t =~ s/>/&gt;/g;
    $t =~ s/"/&quote;/g;

    return $t;
}

1;
