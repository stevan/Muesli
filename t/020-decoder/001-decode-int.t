#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Museli::Decoder');
}

use Museli::Util::Constants;

{
    my ($val, $size) = Museli::Decoder::decode_int( 0, [ VARINT, 0b00000001 ] );

    is($val, 1, '... our binrary data is 1');
    is($size, 2, '... and it took 2 bytes (one for tag, one for value)');
}

{
    my ($val, $size) = Museli::Decoder::decode_int( 0, [ VARINT, 0b10101100, 0b00000010 ] );

    is($val, 300, '... our binary data is 300');
    is($size, 3, '... and it took 3 bytes (one for tag, two for value)');
}

done_testing;