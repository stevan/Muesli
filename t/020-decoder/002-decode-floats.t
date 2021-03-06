#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Devel qw[ FORMAT_BINARY ];
use Muesli::Util::Constants;

# test cases from https://en.wikipedia.org/wiki/Single-precision_floating-point_format

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b00111110, 0b00100000, 0b00000000, 0b00000000 ]
    );

    is($val, 0.15625, '... 0.15625 decoded as expected');
    is($len, 5, '... got the length we expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b00111111, 0b10000000, 0b00000000, 0b00000000 ]
    );

    is($val, 1.0, '... 1.0 decoded as expected');
    is($len, 5, '... got the length we expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b00000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, 0.0, '... 0.0 decoded as expected');
    is($len, 5, '... got the length we expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b10000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, -0.0, '... -0.0 decoded as expected');
    is($len, 5, '... got the length we expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b11000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, -2.0, '... -2.0 decoded as expected');
    is($len, 5, '... got the length we expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode_float(
        0, [ FLOAT, 0b01000001, 0b11001000, 0b00000000, 0b00000000 ]
    );

    is($val, 25, '... 25 decoded as expected');
    is($len, 5, '... got the length we expected');
}


done_testing;