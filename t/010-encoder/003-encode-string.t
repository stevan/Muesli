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
    '01100110 01100001 01100011 10100111 00000110 01100001 01100100 01100101',
    '... façade encoded as expected'
);

done_testing;
