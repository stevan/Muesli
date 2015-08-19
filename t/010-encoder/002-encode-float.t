#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

use Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

# test cases from https://en.wikipedia.org/wiki/Single-precision_floating-point_format

is( 
    bin_fmt(Museli::Encoder::encode_float( 0.15625 )),
    '00111110 00100000 00000000 00000000',
    '... 0.15625 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_float( 1.0 )),
    '00111111 10000000 00000000 00000000',
    '... 1.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_float( 0.0 )),
    '00000000 00000000 00000000 00000000',
    '... 0.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_float( -0.0 )),
    '10000000 00000000 00000000 00000000',
    '... -0.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_float( -2.0 )),
    '11000000 00000000 00000000 00000000',
    '... -2.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_float( 25 )),
    '01000001 11001000 00000000 00000000',
    '... 25 encoded as expected'
);

done_testing;