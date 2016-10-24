#! perl

# Ease the life of the CPAN testers.
exit 0 if $ENV{AUTOMATED_TESTING} && $] < 5.012000;

use ExtUtils::MakeMaker;

my $master = 'lib/Comics.pm';
my $version = MM->parse_version($master);

WriteMakefile
(
 NAME		=> 'Comics',
 ABSTRACT_FROM  => $master,
 VERSION_FROM	=> $master,
 AUTHOR	        => 'Johan Vromans <jvromans@squirrel.nl>',

 INSTALLDIRS	=> 'site',
 EXE_FILES	=> [ 'script/collect' ],
 PL_FILES	=> {
		    'script/pp.PL' => [ 'script/collect' ]
		   },

 PREREQ_PM      => {
		    'Image::Info'   => 0,
		    'LWP::UserAgent'   => 0,
		    'JSON'   => 0,
		    'HTTP::Cookies'   => 0,
		    'Digest::MD5'   => 0,
		   },
 TEST_REQUIRES  => {
		    'Test::More'  => 0,
		   },

 META_MERGE => {
     license          => "perl_5",
 },

);

