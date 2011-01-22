#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Util::IO' );
}

diag( "Testing Util::IO $Util::IO::VERSION, Perl $], $^X" );
