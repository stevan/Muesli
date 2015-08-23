#!perl 

use strict;
use warnings;

use Test::More;
use Test::Museli::Util;

BEGIN {
    use_ok('Museli::Encoder');
}

use Museli::Util::Constants;

# INT

is( 
    bin_fmt(Museli::Encoder::encode( 1 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(VARINT),
        '00000001',
    ),
    '... 1 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( 300 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(VARINT),
        '10101100 00000010',
    ),    
    '... 300 encoded as expected'
);

# FLOAT

is( 
    bin_fmt(Museli::Encoder::encode( 0.15625 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '00111110 00100000 00000000 00000000',
    ),
    '... 0.15625 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( 1.0 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '00111111 10000000 00000000 00000000',
    ),
    '... 1.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( 0.0 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '00000000 00000000 00000000 00000000',
    ),
    '... 0.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( -0.0 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '10000000 00000000 00000000 00000000',
    ),
    '... -0.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( -2.0 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '11000000 00000000 00000000 00000000',
    ),
    '... -2.0 encoded as expected'
);

is( 
    bin_fmt(Museli::Encoder::encode( 25 )),
    (join ' ' => 
        bin_fmt(MAGIC_HEADER),
        bin_fmt(FLOAT), 
        '01000001 11001000 00000000 00000000',
    ),
    '... 25 encoded as expected'
);

# STRING

is( 
    bin_fmt(Museli::Encoder::encode_string( "fac\x{0327}ade" )),
    (join ' ' => 
        bin_fmt(STRING), # tag
        '00001000',      # length 
        (                # codepoints
            '01100110',           # f
            '01100001',           # a
            '01100011',           # c 
            '10100111 00000110',  # \x{0327}
            '01100001',           # a
            '01100100',           # d
            '01100101',           # e
        )
    ),
    '... façade encoded as expected'
);

done_testing;