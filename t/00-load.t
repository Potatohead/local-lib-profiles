#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'local::lib::environment' );
}

diag( "Testing local::lib::environment $local::lib::environment::VERSION, Perl $], $^X" );
