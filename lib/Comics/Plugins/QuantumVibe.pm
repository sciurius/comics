#! perl

use strict;
use warnings;
use utf8;
use Carp;

package Comics::Plugins::QuantumVibe;

use parent qw(Comics::Plugins::Base);

our $VERSION = "0.01";

sub register {
    shift->SUPER::register
      ( { name    => "Quantum Vibe",
	  url     => "http://www.quantumvibe.com",
	  enabled => 1,
	  fetch   => "single",
	  pat	  =>
	    qr{ Strip \s+ \d+ \s+ of \s+ Quantum \s+ Vibe" \s+
		src="(?<url>/disppageV?[34]\?story=qv\&file=/simages/qv/
		  (?<image>[^"]+.jpg))"
	      }x,
	 } );
}

# Important: Return the package name!
__PACKAGE__;
