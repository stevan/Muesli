#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Museli::Decoder');
}

{
    my ($val, $size) = Museli::Decoder::decode_string( 
        0, [ 0b01100110, 0b01100001, 0b01100011, 0b10100111, 
             0b00000110, 0b01100001, 0b01100100, 0b01100101 ] 
    );

    is($val, "fac\x{0327}ade", '... our binary data is façade');
    is($size, 8, '... and it took 8 bytes');
}

done_testing;