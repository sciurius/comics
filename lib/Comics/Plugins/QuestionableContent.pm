#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::QuestionableContent;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Questionable Content",
	  url     => "http://www.questionablecontent.net/",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ <img \s+
		src="(?<url>http://www.questionablecontent.net/comics/
		      (?<image>\d+\.\w+))" \s*
		>
	      }x,
	} );
}

# Important: Return the package name!
__PACKAGE__;
