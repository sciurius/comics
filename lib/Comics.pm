#! perl

# Author          : Johan Vromans
# Created On      : Fri Oct 21 09:18:23 2016
# Last Modified By: Johan Vromans
# Last Modified On: Mon Oct 24 19:58:05 2016
# Update Count    : 203
# Status          : Unknown, Use with caution!

use 5.012;
use strict;
use warnings;
use utf8;
use Carp;

package Comics;

our $VERSION = "0.04";

package main;

################ Common stuff ################

use strict;
use warnings;
use FindBin;

BEGIN {
    # Add private library if it exists.
    if ( -d "$FindBin::Bin/../lib" ) {
	unshift( @INC, "$FindBin::Bin/../lib" );
    }
}

# Package name.
my $my_package = 'Sciurix';
# Program name and version.
my ($my_name, $my_version) = qw( comics 0.05 );

################ Command line parameters ################

use Getopt::Long 2.13;

# Command line options.
our $spooldir = $ENV{HOME} . "/tmp/gotblah/";
my $statefile = $spooldir . ".state.json";
my $refresh;
my $fetchonly;			# debugging
my $verbose = 1;		# verbose processing

# Development options (not shown with -help).
my $debug = 0;			# debugging
my $trace = 0;			# trace (show process)
my $test = 0;			# test mode.

# Extra command line arguments are taken to be plugin names.
# If specified, only named plugins are included.
my $modfilter;

################ Presets ################

my $comics =
  [
   "9 Chickweed Lane",
   "Abstrusegoose",
   "Amazing Super Powers Secret Toon",
   "APOKALIPS",
   "asofterworld",
   "Buttersafe",
   "Calvin and Hobbes",
   "CTRL ALT DEL",
   "Diesel sweeties",
   "Dilbert",
   "Doghouse diaries",
   "Dominic Deegan",
   "Do you know Flo",
   "EEK!",
   "Evert Kwok",
   "Explosm",
   "Extralife",
   "Farcus",
   "Fokke Sukke",
   "Frank and Ernest",
   "Garfield",
   "Garfield Minus Garfield",
   "Geek Poke",
   "Glasbergen",
   "Hein de Kort",
   "Jesus and Mo",
   "Kevin and Kell",
   "Least I Could Do",
   "Lectrrland",
   "Little Gamers",
   "Looking For Group",
   "Megatokyo",
   "Monty",
   "Non Sequitur",
   "Nozzman",
   "Off the mark",
   "Over the hedge",
   "Peanuts",
   "Penny Arcade",
   "Player vs Player",
   "Questionable Content",
   "Red Meat",
   "Rubes",
   "Saturday Morning Breakfast Cereal",
   "Savage Chickens",
   "Sigmund",
   "Sinfest",
   "Soopah! comics",
   "The Joy of Tech",
   "The Ministry of Normality",
   "The Order of the Stick",
   "the WAREHOUSE webcomic",
   "Quantum Vibe",
   "User Friendly",
   "VG Cats",
   "What the Duck",
   "Wondermark",
   "Working Daze",
   "Wulffmorgenthaler",
   "XKCD",
   "You're all just jealous of my Jetpack",
  ];

################ The Process ################

# Statistics.
our $stats;

sub init {
    $stats =
      { tally => 0,
	fail => 0,
	uptodate => 0,
      };

    # Process command line options.
    app_options();

    # Post-processing.
    $trace |= ($debug || $test);
    $spooldir .= "/";
    $spooldir =~ s;/+$;/;;

    $modfilter = ".";
    if ( @ARGV ) {
	$modfilter = "^(?:" . join("|", @ARGV) . ")\\.pm\$";
    }
    $modfilter = qr($modfilter)i;

}

sub main {

    # Initialize.
    init();

    # Load the plugins.
    load_plugins();

    # Restore state of previous run.
    get_state();

    # Run the plugins to fetch new images.
    run_plugins();

    # Save the state.
    save_state();

    # Gather the HTML fragmnt into a single index.html.
    build();

    # Show processing statistics.
    statistics();
}

################ Subroutines ################

use JSON;

my $state;

sub get_state {
    return {} if $refresh || $fetchonly;
    if ( open( my $fd, '<', $statefile ) ) {
	my $data = do { local $/; <$fd>; };
	$state = JSON->new->decode($data);
    }
    else {
	$state = { comics => { } };

    }
}

sub save_state {
    return if $fetchonly;
    open( my $fd, '>', $statefile );
    print $fd JSON->new->canonical->pretty(1)->encode($state);
    close($fd);
}


my @plugins;

sub load_plugins {

    opendir( my $dh, $INC[0] . "/Comics/Plugin" )
      or die( $INC[0] . "/Comics/Plugin: $!\n");

    while ( my $m = readdir($dh) ) {
	next unless $m =~ /^[0-9A-Z].*\.pm$/;
	next unless $m =~ $modfilter;
	debug("Loading $m...");
	my $pkg = eval { require "Comics/Plugin/$m" };
	die("Comics::Plugin::$m: $@\n") unless $pkg;
	next unless $pkg =~ /^Comics::Plugin::/;
	my $ctl = $pkg->register;
	push( @plugins, $ctl );
    }

}

use LWP::UserAgent;

our $ua;
our $uuid;

sub run_plugins {

    unless ( $ua ) {
	$ua = LWP::UserAgent::Custom->new;
	$uuid = uuid();
    }

    foreach my $comic ( @plugins ) {
	# debug("SKIP: ", $comic->{name}), next if !$comic->{enabled};
	debug("COMIC: ", $comic->{name});
	$state->{comics}->{$comic->{tag}} ||= {};
	$comic->{state} = $state->{comics}->{$comic->{tag}};
	$comic->fetch;
    }
}

sub build {

    # Change to the spooldir and collect all HTML fragments.
    chdir($spooldir) or die("$spooldir: $!\n");
    opendir( my $dir, "." );
    my @files = grep { /^[^._].+(?<!index)\.(?:html)$/ } readdir($dir);
    close($dir);
    warn("Number of images = ", scalar(@files), "\n") if $debug;

    # Sort the fragments on last modification date.
    @files =
      map { $_->[-1] }
	sort { $b->[9] <=> $a->[9] }
	  map { [ stat($_), $_ ] }
	    @files;

    if ( $debug && !$fetchonly ) {
	warn("Images (sorted):\n");
	warn("   $_\n") for @files;
    }

    # Create a new index.html.
    open( my $fd, '>:utf8', "index.html" );
    preamble($fd);
    htmlstats($fd);
    for ( @files ) {
	open( my $hh, '<:utf8', $_ )
	  or die("$_: $!");
	print { $fd } <$hh>;
	close($hh);
    }
    postamble($fd);
    close($fd);
}

sub preamble {
    my ( $fd ) = @_;
    print $fd <<EOD;
<html>
<head>
<title>TOONS!</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<style type="text/css">
    body {
	font-family : Verdana, Arial, Helvetica, sans-serif;
	text-align: center;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 10px;
	margin-left: 0px;
	font-size:12pt;
    }
    .toontable {
	background-color: #eee;
	padding: 9px;
	margin: 18px;
	border: 1px solid #ddd;
    }
</style>
</head>
<body bgcolor='#ffffff'>
<div align="center">
EOD
}

sub postamble {
    my ( $fd ) = @_;
    print $fd <<EOD;
</div>
</body>
</html>
EOD
}

sub htmlstats {
    my ( $fd ) = @_;
    print $fd <<EOD;
<table class="toontable" cellpadding="0" cellspacing="0">
  <tr><td nowrap align="left" valign="top">
        <font size="-2">Last run: @{[ "".localtime() ]} &#x2013; @{[ statmsg() ]}</font><br>
      </td>
  </tr>
</table>
EOD
}

sub statistics {
    return unless $verbose;
    warn( statmsg(), "\n" );
}

sub statmsg {
    join( '', "Number of comics = ", $stats->{tally}, ", ",
	  $stats->{tally} - $stats->{uptodate} - $stats->{fail}, " new, ",
	  $stats->{uptodate}, " uptodate, ",
	  $stats->{fail}, " fail." );
}

sub uuid {
    my @chars = ( 'a'..'f', 0..9 );
    my @string;
    push( @string, $chars[int(rand(16))]) for (1..32);
    splice( @string,  8, 0, '-');
    splice( @string, 13, 0, '-');
    splice( @string, 18, 0, '-');
    splice( @string, 23, 0, '-');
    return join('', @string);
}

sub debug {
    return unless $debug;
    warn(@_,"\n");
}

################ Subroutines ################

sub app_options {
    my $help = 0;		# handled locally
    my $ident = 0;		# handled locally
    my $man = 0;		# handled locally

    my $pod2usage = sub {
        # Load Pod::Usage only if needed.
        require Pod::Usage;
        Pod::Usage->import;
        &pod2usage;
    };

    # Process options.
    if ( @ARGV > 0 ) {
	GetOptions('spooldir=s' => \$spooldir,
		   'refresh'	=> \$refresh,
		   'fetchonly'  => \$fetchonly,
		   'ident'	=> \$ident,
		   'verbose+'	=> \$verbose,
		   'quiet'	=> sub { $verbose = 0 },
		   'trace'	=> \$trace,
		   'help|?'	=> \$help,
		   'man'	=> \$man,
		   'debug'	=> \$debug)
	  or $pod2usage->(2);
    }
    if ( $ident or $help or $man ) {
	print STDERR ("This is $my_package [$my_name $my_version]\n");
    }
    if ( $man or $help ) {
	$pod2usage->(1) if $help;
	$pod2usage->(VERBOSE => 2) if $man;
    }
}

################ Documentation ################

=head1 NAME

Comics - comics aggregator in the style of Gotblah

=head1 SYNOPSIS

  perl Comics.pm [options] [plugin ...]

If the associated C<collect> tool has been installed properly:

  collect [options] [plugin ...]

   Options:
     --spooldir=XXX	where resultant images and index must be stored
     --refresh		consider all images as new
     --ident		shows identification
     --help		shows a brief help message and exits
     --man                shows full documentation and exits
     --verbose		provides more verbose information
     --quiet		provides no information unless failure

=head1 OPTIONS

=over 8

=item B<--spooldir=>I<XXX>

Designates the spool area. Downloaded comics and index files are
written here.

=item B<--help>

Prints a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--ident>

Prints program identification.

=item B<--verbose>

Provides more verbose information. This option may be repeated for
even more verbose information.

=item B<--quiet>

Silences verbose information.

=item I<plugin>

If present, process only the specified plugins.

Mostly for testing.

=back

=head1 DESCRIPTION

This program will load the available plugins and run all of them.

The plugins will examine the contents of comics sites and update the
'cartoon of the day' in the spool area.

Upon completion, an index.html is generated in the spool area to view
the comics collection.

It is best to run this program from the spool area itself.

=head1 PLUGINS

B<Important:> This program assumes that the plugins can be found in
C<../lib> relative to the location of the executable file.

All suitable C<Comics::Plugin::>I<plugin>C<.pm> files are examined
and loaded.

Plugins are derived from Fetcher classes, see below.

See L<Comics::Plugin::Sigmund> for a fully commented plugin.

=head1 FETCHERS

Fetchers implement different fetch strategies. Currently provided are:

L<Comics::Fetcher::Direct> - fetch a comic by URL.

L<Comics::Fetcher::Single> - fetch a comic by examining the comic's home page.

L<Comics::Fetcher::GoComics> - fetch a comic from a GoComics site.

=cut

package LWP::UserAgent::Custom;
use parent qw(LWP::UserAgent);

use HTTP::Cookies;
my $cookie_jar;

sub new {
    my ( $pkg ) = @_;
    my $self = $pkg->SUPER::new();
    bless $self, $pkg;

    $self->agent('Mozilla/5.0 (X11; Linux x86_64; rv:21.0) Gecko/20100101 Firefox/21.0');
    $self->timeout(10);
    $cookie_jar ||= HTTP::Cookies->new
      (
       file	       => "$::spooldir/.lwp_cookies.dat",
       autosave	       => 1,
       ignore_discard  => 1,
      );
    $self->cookie_jar($cookie_jar);

    return $self;
}

sub get {
    my ( $self, $url ) = @_;

    my $res;

    my $sleep = 1;
    for ( 0..4 ) {
	$res = $self->SUPER::get($url);
	$cookie_jar->save;
	last if $res->is_success;
	# Some sites block LWP queries. Show why.
	if ( $res->status_line =~ /^403/ ) {
	    use Data::Dumper;
	    warn(Dumper($res));
	    exit;
	}
	last if $res->status_line !~ /^5/; # not temp fail
	print STDERR "Retry...";
	sleep $sleep;
	$sleep += $sleep;
    }

    return $res;
}

1;

=head1 ACKNOWLEDGEMENTS

The people behind Gotblah, for creating the original tool.

=head1 LICENSE

Copyright (C) 2016, Johan Vromans,

This module is free software. You can redistribute it and/or
modify it under the terms of the Artistic License 2.0.

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

package main;

unless ( caller ) {
    main();
}

1;
