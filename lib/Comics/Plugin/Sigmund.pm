#! perl

use strict;
use warnings;

=head1 NAME

Sigmund - Fully commented plugin for Comics.

=head1 SYNOPSIS

Please read the comments in the source.

=head1 DESCRIPTION

This plugin handles the Sigmund comics from http://www.sigmund.nl .

It is also a commented example of how to write your own plugins.

=cut

# All plugins fall under the Comics::Plugin hierarchy.
#
# Please choose a descriptive name for the plugin.
#
# Some examples:
#
#   Comics::Plugin::9ChickweedLane
#   Comics::Plugin::CalvinAndHobbes
#   Comics::Plugin::FokkeEnSukke
#   Comics::Plugin::LeastICouldDo
#   Comics::Plugin::SMBC (Saturday Morning Breakfast Cerial)

package Comics::Plugin::Sigmund;

# Plugins inherit from a Fetcher and must implement a 'register'
# method. See below.
#
# Currently the following Fetchers are implemented:
#
#   Comics::Fetcher::Direct
#
#      Requires a 'path' and performs a direct fetch of the
#      specified URI.
#
#      See Comics::Plugin::LeastICouldDo for an example.
#
#   Comics::Fetcher::Single
#
#      Requires a pattern 'pat'. The fetcher fetches the main page
#      and uses this pattern to find the URL of the actual image.
#
#   Comics::Fetcher::GoComics
#
#      A special Fetcher for comics that reside on GoComics.com.
#
#      Only the starting URL 'url' is required.
#
#      See Comics::Plugin::Garfield for an example.

# This plugin uses the Simple Fetcher.

use parent qw(Comics::Fetcher::Single);

our $VERSION = "0.03";

# A plugin must implement the 'register' method.

sub register {

    # Just call the SUPER and supply our arguments.
    #
    # Mandatory arguments:
    #
    #  name   : the full name of this comic, e.g. "Fokke en Sukke"
    #  url    : the base url of this comic
    #
    # Other arguments depend on the Fetcher.
    #
    # For the Direct Fetcher:
    #
    #  path   : the path, relative to the url, to the image
    #
    # For the Single Fetcher:
    #
    #  pat    : a pattern to locate the image URI.
    #           When the pattern matches it must define at least
    #           the following named captures:
    #             url    : the (relative) url of the image
    #             image  : the image name within the url
    #
    #           Optionally it may define:
    #
    #             title  : the image title
    #             alt    : the alternative text
    #
    # For the GoComics Fetcher:
    #
    #  url    : the base url of this comic

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

# Important: Return the package name!
__PACKAGE__;
