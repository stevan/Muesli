#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Constants;

# http://docstore.mik.ua/orelly/perl4/cook/ch01_05.htm

{
    my ($val, $size) = Muesli::Decoder::decode_string( 
        0, 
        [ 
            STRING,            # tag
            0b00001000,        # length 
            (                  # codepoints
                0b01100110,             # f
                0b01100001,             # a
                0b01100011,             # c 
                0b10100111, 0b00000110, # \x{0327}
                0b01100001,             # a
                0b01100100,             # d
                0b01100101,             # e
            )
        ],
    );

    is($val, "fac\x{0327}ade", '... our binary data is fac\x{0327}ade');
    is($size, 10, '... and it took 10 bytes');
}

done_testing;