#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

is( 
    bin_fmt(Museli::Encoder::encode_string( "fac\x{0327}ade" )),
    (join ' ' => 
        '00100111',          # tag
        '00100000 00001111', # length 
        (   # tag       # varint
            '00100000', '01100110',            # f
            '00100000', '01100001',            # a
            '00100000', '01100011',            # c 
            '00100000', '10100111 00000110',   # \x{0327}
            '00100000', '01100001',            # a
            '00100000', '01100100',            # d
            '00100000', '01100101',            # e
        )
    ),
    '... façade encoded as expected'
);

done_testing;
