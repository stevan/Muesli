#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

use Museli::Util;

BEGIN {
    use_ok('Museli::Decoder');
}

{
    my ($val, $len) = Museli::Decoder::decode_float(
        0b00111110, 0b00100000, 0b00000000, 0b00000000
    );

    is($val, 0.15625, '... 0.15625 decoded as expected');
    is($len, 4, '... got the length we expected');
}

done_testing;