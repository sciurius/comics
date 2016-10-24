A comics aggregator in the style of Gotblah.

This one runs privately and generates a static comics page.
No web servers required.

USAGE

Unpack the sources somewhere in a convenient place, for example
$HOME/Comics .

Create a spool directory to contain the generated data files.
For example, $HOME/Comics/spool .

Install a cron job to run the collect script every hour or so:

00 * * * *  perl $HOME/Comics/script/comics.pl --spooldir=$HOME/Comics/spool

If everything goes well, point your browser at
$HOME/Comics/spool/index.html .

Feel free to fork and improve, especially add more plugins!

Plugin Comics/Plugin/Sigmund.pm is fully documented and can be use as
a starting point to develop your own plugins.

LICENSE

Copyright (C) 2016 Johan Vromans,

This module is free software. You can redistribute it and/or modify it
under the terms of the Artistic License 2.0.
