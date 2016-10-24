#!perl

my @modules;

BEGIN {
    @modules = 	( 'Comics',
		  'Comics::Fetcher::Base',
		  'Comics::Fetcher::Direct',
		  'Comics::Fetcher::GoComics',
		  'Comics::Fetcher::Single',
		  'Comics::Plugin::Base',
		  'Comics::Plugin::Sigmund',
		);
}

use Test::More tests => scalar @modules;

BEGIN {
    use_ok($_) foreach @modules;
}

diag( "Testing Comics $Comics::VERSION, Perl $], $^X" );
