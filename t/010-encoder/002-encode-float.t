#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

use Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

is( 
    bin_fmt(Museli::Encoder::encode_float( 0.15625 )),
    '00111110 00100000 00000000 00000000',
    '... 0.15625 encoded as expected'
);

done_testing;