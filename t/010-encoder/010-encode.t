#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Devel qw[ FORMAT_BINARY ];
use Muesli::Util::Constants;

# INT

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 1 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(VARINT),
        '00000001',
    ),
    '... 1 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 300 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(VARINT),
        '10101100 00000010',
    ),    
    '... 300 encoded as expected'
);

# FLOAT

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 0.15625 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '00111110 00100000 00000000 00000000',
    ),
    '... 0.15625 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 1.0 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '00111111 10000000 00000000 00000000',
    ),
    '... 1.0 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 0.0 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '00000000 00000000 00000000 00000000',
    ),
    '... 0.0 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( -0.0 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '10000000 00000000 00000000 00000000',
    ),
    '... -0.0 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( -2.0 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '11000000 00000000 00000000 00000000',
    ),
    '... -2.0 encoded as expected'
);

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 25.0 ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(FLOAT), 
        '01000001 11001000 00000000 00000000',
    ),
    '... 25.0 encoded as expected'
);

# STRING

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( "façade" ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(STRING), # tag
        '00000111',      # length 
        (                # codepoints
            '01100110',           # f
            '01100001',           # a
            '11000011 10100111',  # ç 
            '01100001',           # a
            '01100100',           # d
            '01100101',           # e
        )
    ),
    '... façade encoded as expected'
);

# UNDEF 

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( undef ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(UNDEF) # just the tag ma'am
    ),
    '... undef encoded as expected'
);

# ARRAY 

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( [ 1, 300, -1, -300 ] ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(ARRAY), # tag
        '00000100',      # length 
        (                # elements
            (FORMAT_BINARY(VARINT), '00000001'),           # 1
            (FORMAT_BINARY(VARINT), '10101100 00000010'),  # 300 
            (FORMAT_BINARY(ZIGZAG), '00000001'),           # -1
            (FORMAT_BINARY(ZIGZAG), '11010111 00000100'),  # -300
        )
    ),
    '... array encoded as expected'
);

# HASH 

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( { foo => 1 } ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(HASH), # tag
        '00000001',      # length 
        (                # elements
            (FORMAT_BINARY(STRING), '00000011 01100110 01101111 01101111'), # foo
            (FORMAT_BINARY(VARINT), '00000001'),                            # 1
        )
    ),
    '... hash encoded as expected'
);

# OMGBBQ!!!!1!!

is( 
    FORMAT_BINARY(@{ Muesli::Encoder::encode( 
        { 
            foo => 1,
            bar => [ 1, -300 ],
            baz => { 
                gorch => 1000
            }
        } 
    ) }),
    (join ' ' => 
        FORMAT_BINARY(MAGIC_HEADER),
        FORMAT_BINARY(HASH), # tag
        '00000011',      # length 
        (                # elements
            (FORMAT_BINARY(STRING), '00000011 01100010 01100001 01110010'), # bar
            (
                FORMAT_BINARY(ARRAY), 
                '00000010',
                (
                    (FORMAT_BINARY(VARINT), '00000001'),           # 1
                    (FORMAT_BINARY(ZIGZAG), '11010111 00000100'),  # -300 
                ),
            ),

            (FORMAT_BINARY(STRING), '00000011 01100010 01100001 01111010'), # baz
            (
                FORMAT_BINARY(HASH), 
                '00000001',
                (
                    (FORMAT_BINARY(STRING), '00000101 01100111 01101111 01110010 01100011 01101000'), # gorch
                    (FORMAT_BINARY(VARINT), '11101000 00000111'),                                     # 1000 
                ),
            ),

            (FORMAT_BINARY(STRING), '00000011 01100110 01101111 01101111'), # foo
            (FORMAT_BINARY(VARINT), '00000001'),                            # 1
        ),
    ),
    '... bunch of random stuff encoded as expected'
);

done_testing;