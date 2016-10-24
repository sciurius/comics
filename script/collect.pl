#!/usr/bin/perl -w

# Author          : Johan Vromans
# Created On      : Fri Oct 21 09:18:23 2016
# Last Modified By: Johan Vromans
# Last Modified On: Mon Oct 24 15:15:43 2016
# Update Count    : 188
# Status          : Unknown, Use with caution!

################ Common stuff ################

use 5.012;
use strict;
use warnings;
use FindBin;

BEGIN {
    # Add private library if it exists.
    if ( -d "$FindBin::Bin/../lib" ) {
	unshift( @INC, "$FindBin::Bin/../lib" );
    }
}

use Comics;

main();

1;
