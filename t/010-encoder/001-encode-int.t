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
    bin_fmt(Muesli::Encoder::encode_int( 1 )),
    (join ' ' => 
        bin_fmt(VARINT),
        '00000001',
    ),
    '... 1 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_int( 300 )),
    (join ' ' => 
        bin_fmt(VARINT),
        '10101100 00000010',
    ),    
    '... 300 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_int( -1 )),
    (join ' ' => 
        bin_fmt(ZIGZAG),
        '00000001',
    ),
    '... -1 encoded as expected'
);

is( 
    bin_fmt(Muesli::Encoder::encode_int( -300 )),
    (join ' ' => 
        bin_fmt(ZIGZAG),
        '11010111 00000100',
    ),
    '... -300 encoded as expected'
);

done_testing;