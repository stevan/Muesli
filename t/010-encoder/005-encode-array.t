#!perl 

use strict;
use warnings;

use Test::More;
use Test::Muesli::Util;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Constants;

is( 
    bin_fmt(Muesli::Encoder::encode_array( [ 1, 300, -1, -300 ] )),
    (join ' ' => 
        bin_fmt(ARRAY), # tag
        '00001010',      # length 
        (                # elements
            (bin_fmt(VARINT), '00000001'),           # 1
            (bin_fmt(VARINT), '10101100 00000010'),  # 300 
            (bin_fmt(ZIGZAG), '00000001'),           # -1
            (bin_fmt(ZIGZAG), '11010111 00000100'),  # -300
        )
    ),
    '... array encoded as expected'
);

done_testing;
