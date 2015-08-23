#!perl 

use strict;
use warnings;

use Test::More;
use Test::Muesli::Util;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Constants;

is( 
    bin_fmt(Muesli::Encoder::encode_string( "fac\x{0327}ade" )),
    (join ' ' => 
        bin_fmt(STRING), # tag
        '00001000',      # length 
        (                # codepoints
            '01100110',           # f
            '01100001',           # a
            '01100011',           # c 
            '10100111 00000110',  # \x{0327}
            '01100001',           # a
            '01100100',           # d
            '01100101',           # e
        )
    ),
    '... façade encoded as expected'
);

done_testing;
