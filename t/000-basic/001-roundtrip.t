#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli');
}

my $data = { 
    foo => 1,
    bar => [ 1, -300 ],
    baz => { 
        gorch => 1000
    }
};

is_deeply( Muesli::decode( Muesli::encode( $data ) ), $data, '... roundtrippin it' );

done_testing;
