#!/usr/bin/perl -w

# Author          : Johan Vromans
# Created On      : Fri Oct 21 09:18:23 2016
# Last Modified By: Johan Vromans
# Last Modified On: Sat Oct 22 21:07:05 2016
# Update Count    : 141
# Status          : Unknown, Use with caution!

################ Common stuff ################

use 5.012;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

# Package name.
my $my_package = 'Sciurix';
# Program name and version.
my ($my_name, $my_version) = qw( comics 0.01 );

################ Command line parameters ################

use Getopt::Long 2.13;

# Command line options.
our $spooldir = $ENV{HOME} . "/tmp/gotblah/";
my $statefile = $spooldir . ".state.json";
my $refresh;
my $fetchonly;			# for debugging
my $verbose = 0;		# verbose processing

# Development options (not shown with -help).
my $debug = 0;			# debugging
my $trace = 0;			# trace (show process)
my $test = 0;			# test mode.

# Process command line options.
app_options();

# Post-processing.
$trace |= ($debug || $test);

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

load_plugins();
get_state();
collect();
save_state();

build();

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
	$state = { comics => { map { $_ => {} } @$comics } };

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

    opendir( my $dh, $INC[0] . "/Comics/Plugins" )
      or die("plugins: $!\n");
    while ( my $m = readdir($dh) ) {
	next unless $m =~ /^[0-9A-Z].*\.pm$/;
	next if $m eq "Base.pm";
	next if $fetchonly && "$fetchonly.pm" ne $m;
	debug("Loading $m...");
	my $pkg = eval { require "Comics/Plugins/$m" };
	die("Comics::Plugins::$m: $@\n") unless $pkg;
	my $ctl = $pkg->register;
	push( @plugins, $ctl );
    }

}

sub run_plugins {
    foreach my $comic ( @plugins ) {
	debug("SKIP: ", $comic->{name}), next if !$comic->{enabled};
	debug("COMIC: ", $comic->{name});
	$state->{comics}->{$comic->{tag}} =
	  $comic->fetch( $state->{comics}->{$comic->{tag}} );
    }
}

use LWP::UserAgent;

our $ua;
our $uuid;
our $ts;

sub collect {

    unless ( $ua ) {
	$ua = LWP::UserAgent::Custom->new;
	$uuid = uuid();
	$ts = time;
    }

=begin xxx

    foreach my $comic ( keys %{ $state->{comics} } ) {
	debug("SKIP: $comic"), next if $comic =~ /^-/;
	my $action = $comic;
	$action =~ s/\s+/_/g;
	debug("SKIP: $comic"), next unless $action = main::->can($action);
	debug("COMIC: $comic");
	$state->{comics}->{$comic} = $action->( $state->{comics}->{$comic} );
    }

=cut

    run_plugins();
}

sub build {
    chdir($spooldir) or die("$spooldir: $!\n");
    opendir( my $dir, "." );
    my @files = grep { /^[^._].+(?<!index)\.(?:html)$/ } readdir($dir);
    close($dir);
    warn("Number of images = ", scalar(@files), "\n") if $debug;

    # Sort on last modification date.
    @files =
      map { $_->[-1] }
	sort { $b->[9] <=> $a->[9] }
	  map { [ stat($_), $_ ] }
	    @files;

    if ( $debug && !$fetchonly ) {
	warn("Images (sorted):\n");
	warn("   $_\n") for @files;
    }

    open( my $fd, '>:utf8', "index.html" );
    preamble($fd);
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
		   'fetchonly=s'=> \$fetchonly,
		   'ident'	=> \$ident,
		   'verbose'	=> \$verbose,
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

sample - skeleton for GetOpt::Long and Pod::Usage

=head1 SYNOPSIS

sample [options] [file ...]

 Options:
   --ident		shows identification
   --help		shows a brief help message and exits
   --man                shows full documentation and exits
   --verbose		provides more verbose information

=head1 OPTIONS

=over 8

=item B<--help>

Prints a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--ident>

Prints program identification.

=item B<--verbose>

Provides more verbose information.

=item I<file>

The input file(s) to process, if any.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do someting
useful with the contents thereof.

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
       file		   => '.lwp_cookies.dat',
       autosave	   => 1,
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
