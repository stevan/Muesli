#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Devel qw[ FORMAT_BINARY ];
use Muesli::Util::Constants;

is( 
    FORMAT_BINARY(Muesli::Encoder::encode_array( [ 1, 300, -1, -300 ] )),
    (join ' ' => 
        FORMAT_BINARY(ARRAY), # tag
        '00001010',      # length 
        (                # elements
            (FORMAT_BINARY(VARINT), '00000001'),           # 1
            (FORMAT_BINARY(VARINT), '10101100 00000010'),  # 300 
            (FORMAT_BINARY(ZIGZAG), '00000001'),           # -1
            (FORMAT_BINARY(ZIGZAG), '11010111 00000100'),  # -300
        )
    ),
    '... array encoded as expected'
);

done_testing;
