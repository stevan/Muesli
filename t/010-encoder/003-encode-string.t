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
        bin_fmt(STRING),          # tag
        '00100000 00001111', # length 
        (   # tag       # varint
            bin_fmt(INT), '01100110',            # f
            bin_fmt(INT), '01100001',            # a
            bin_fmt(INT), '01100011',            # c 
            bin_fmt(INT), '10100111 00000110',   # \x{0327}
            bin_fmt(INT), '01100001',            # a
            bin_fmt(INT), '01100100',            # d
            bin_fmt(INT), '01100101',            # e
        )
    ),
    '... façade encoded as expected'
);

done_testing;
