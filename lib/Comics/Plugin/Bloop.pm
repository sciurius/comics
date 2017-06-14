#! perl

use strict;
use warnings;

package Comics::Plugin::Bloop;

use parent qw(Comics::Fetcher::Single);

our $VERSION = "1.00";

our $name    = "JHall Bloop";
our $url     = "http://jhallcomics.com/Bloop/";

our $pattern =
  qr{ <div \s+ class="sixteen\scolumns" \s+ id="comic-container"> \s+
      <img \s+
       src="(?<url>/sites/default/files/styles/comic/public/(?<image>.+?\.\w+))"
       .*?
       <div \s+ class="sixteen\scolumns"> \s+
         <div \s+ id="comment"> \s+
	   <p> \s+
	     <div .*? ><div .*? ><div .*? >
	       <p>(?<alt> .*? )</p> \s+
            </div></div></div>
    }sx;

# Important: Return the package name!
__PACKAGE__;
