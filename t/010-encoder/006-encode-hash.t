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
    FORMAT_BINARY(Muesli::Encoder::encode_hash( { foo => 1 } )),
    (join ' ' => 
        FORMAT_BINARY(HASH), # tag
        '00000111',      # length 
        (                # elements
            (FORMAT_BINARY(STRING), '00000011 01100110 01101111 01101111'), # foo
            (FORMAT_BINARY(VARINT), '00000001'),                                     # 1
        )
    ),
    '... hash encoded as expected'
);

done_testing;
