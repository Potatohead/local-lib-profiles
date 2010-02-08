#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'local::lib::profiles' );
}

diag( "Testing local::lib::profiles $local::lib::profiles::VERSION, Perl $], $^X" );
