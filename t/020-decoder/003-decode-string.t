#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Museli::Decoder');
}

use Museli::Util::Constants;

{
    my ($val, $size) = Museli::Decoder::decode_string( 
        0, 
        [ 
            STRING,
            0b00100000, 0b00001111, # length 
            ( # tag  # varint
                INT, 0b01100110,             # f
                INT, 0b01100001,             # a
                INT, 0b01100011,             # c 
                INT, 0b10100111, 0b00000110, # \x{0327}
                INT, 0b01100001,             # a
                INT, 0b01100100,             # d
                INT, 0b01100101,             # e
            )
        ],
    );

    is($val, "fac\x{0327}ade", '... our binary data is fac\x{0327}ade');
    is($size, 18, '... and it took 18 bytes');
}

done_testing;