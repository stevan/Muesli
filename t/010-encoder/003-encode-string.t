#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

use Museli::Util::Constants;

is( 
    bin_fmt(Museli::Encoder::encode_string( "fac\x{0327}ade" )),
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
