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
    my ($val, $size) = Muesli::Decoder::decode_array( 
        0, 
        [ 
            ARRAY, # tag
            0b00000100,      # length 
            (                # elements
                (VARINT, 0b00000001),             # 1
                (VARINT, 0b10101100, 0b00000010), # 300 
                (ZIGZAG, 0b00000001),             # -1
                (ZIGZAG, 0b11010111, 0b00000100), # -300
            )
        ],
    );

    is_deeply($val, [ 1, 300, -1, -300 ], '... our binary data is [ 1, 300, -1, -300 ] as expected');
    is($size, 12, '... and it took 12 bytes');
}

done_testing;
