#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

is( 
    bin_fmt(Museli::Encoder::encode_int( 1 )),
    '00000001',
    '... 1 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_int( 300 )),
    '10101100 00000010',
    '... 300 encoded as expected'
);

done_testing;