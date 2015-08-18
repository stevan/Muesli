#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Museli::Encoder');
}

is( 
    (join " " => map { sprintf '%08b' => $_ } Museli::Encoder::encode_varint( 1 )),
    '00000001',
    '... 1 encoded as expected'
);

is( 
    (join " " => map { sprintf '%08b' => $_ } Museli::Encoder::encode_varint( 300 )),
    '10101100 00000010',
    '... 300 encoded as expected'
);

done_testing;