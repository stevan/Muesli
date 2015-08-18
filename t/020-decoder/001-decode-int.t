#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Museli::Decoder');
}

{
    my ($val, $size) = Museli::Decoder::decode_int( 0b00000001 );

    is($val, 1, '... our binrary data is 1');
    is($size, 1, '... and it took 1 byte');
}

{
    my ($val, $size) = Museli::Decoder::decode_int( 0b10101100, 0b00000010 );

    is($val, 300, '... our binrary data is 300');
    is($size, 2, '... and it took 2 bytes');
}

done_testing;