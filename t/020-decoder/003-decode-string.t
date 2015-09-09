#!perl 

use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Constants;

{
    my ($val, $size) = Muesli::Decoder::decode_string( 
        0, 
        [ 
            STRING,            # tag
            0b00000111,        # length 
            (                  # codepoints
                0b01100110,             # f
                0b01100001,             # a
                0b11000011, 0b10100111, # ç 
                0b01100001,             # a
                0b01100100,             # d
                0b01100101,             # e
            )
        ],
    );

    is($val, "façade", '... our binary data is façade');
    is($size, 9, '... and it took 9 bytes');
}

done_testing;