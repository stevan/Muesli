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
        bin_fmt(VARINT), '00001111', # length 
        (   # tag       # varint
            bin_fmt(VARINT), '01100110',            # f
            bin_fmt(VARINT), '01100001',            # a
            bin_fmt(VARINT), '01100011',            # c 
            bin_fmt(VARINT), '10100111 00000110',   # \x{0327}
            bin_fmt(VARINT), '01100001',            # a
            bin_fmt(VARINT), '01100100',            # d
            bin_fmt(VARINT), '01100101',            # e
        )
    ),
    '... façade encoded as expected'
);

done_testing;
