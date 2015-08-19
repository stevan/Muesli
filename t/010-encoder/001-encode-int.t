#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

is( 
    bin_fmt(Museli::Encoder::encode_int( 1 )),
    (join ' ' => 
        '00100000', # tag 
        '00000001',
    ),
    '... 1 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode_int( 300 )),
    (join ' ' => 
        '00100000', # tag 
        '10101100 00000010',
    ),    
    '... 300 encoded as expected'
);

done_testing;