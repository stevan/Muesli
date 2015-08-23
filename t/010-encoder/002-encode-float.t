#!perl 

use strict;
use warnings;

use Test::More;
use Test::Muesli::Util;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Constants;

# test cases from https://en.wikipedia.org/wiki/Single-precision_floating-point_format

is( 
    bin_fmt(Muesli::Encoder::encode_float( 0.15625 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '00111110 00100000 00000000 00000000',
    ),
    '... 0.15625 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_float( 1.0 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '00111111 10000000 00000000 00000000',
    ),
    '... 1.0 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_float( 0.0 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '00000000 00000000 00000000 00000000',
    ),
    '... 0.0 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_float( -0.0 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '10000000 00000000 00000000 00000000',
    ),
    '... -0.0 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_float( -2.0 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '11000000 00000000 00000000 00000000',
    ),
    '... -2.0 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_float( 25 )),
    (join ' ' => 
        bin_fmt(FLOAT), 
        '01000001 11001000 00000000 00000000',
    ),
    '... 25 encoded as expected'
);

done_testing;