#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Devel qw[ FORMAT_BINARY ];
use Muesli::Util::Constants;

{
    my ($val, $size) = Muesli::Decoder::decode_hash( 
        0, 
        [ 
            HASH, # tag
            0b00000111,      # length 
            (                # elements
                STRING, 0b00000011, 0b01100110, 0b01101111, 0b01101111, # foo
                VARINT, 0b00000001,                                     # 1
            )
        ],
    );

    is_deeply($val, { foo => 1 }, '... our binary data is { foo => 1 } as expected');
    is($size, 9, '... and it took 9 bytes');
}

done_testing;
