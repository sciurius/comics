A comics collector in the style of Gotblah.

This one runs privately and generates a static comics page.

Usage

Unpack the sources somewhere in a convenient place, for example
$HOME/Comics .

Create a spool directory to contain the generated data files.
For example, $HOME/Comics/spool .

Install a cron job to run the collect script every hour:

00 * * * *  perl $HOME/Comics/script/comics.pl --spooldir=$HOME/Comics/spool

If everything goes well, point your browser at
$HOME/Comics/spool/index.html .

Feel free to fork and improve, especially add more plugins!
