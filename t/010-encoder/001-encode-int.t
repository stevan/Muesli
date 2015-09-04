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
    FORMAT_BINARY(Muesli::Encoder::encode_int( 1 )),
    (join ' ' => 
        FORMAT_BINARY(VARINT),
        '00000001',
    ),
    '... 1 encoded as expected'
);

is( 
    FORMAT_BINARY(Muesli::Encoder::encode_int( 300 )),
    (join ' ' => 
        FORMAT_BINARY(VARINT),
        '10101100 00000010',
    ),    
    '... 300 encoded as expected'
);

is( 
    FORMAT_BINARY(Muesli::Encoder::encode_int( -1 )),
    (join ' ' => 
        FORMAT_BINARY(ZIGZAG),
        '00000001',
    ),
    '... -1 encoded as expected'
);

is( 
    FORMAT_BINARY(Muesli::Encoder::encode_int( -300 )),
    (join ' ' => 
        FORMAT_BINARY(ZIGZAG),
        '11010111 00000100',
    ),
    '... -300 encoded as expected'
);

done_testing;