#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Constants;

# int

{
    my $val = Muesli::Decoder::decode( [ MAGIC_HEADER, VARINT, 0b00000001 ] );

    is($val, 1, '... our binary data is 1');
}

{
    my $val = Muesli::Decoder::decode( [ MAGIC_HEADER, VARINT, 0b10101100, 0b00000010 ] );

    is($val, 300, '... our binary data is 300');
}

{
    my $val = Muesli::Decoder::decode( [ MAGIC_HEADER, ZIGZAG, 0b00000001 ] );

    is($val, -1, '... our binary data is -1');
}

{
    my $val = Muesli::Decoder::decode( [ MAGIC_HEADER, ZIGZAG, 0b11010111, 0b00000100 ] );

    is($val, -300, '... our binary data is -300');
}

# floats
# test cases from https://en.wikipedia.org/wiki/Single-precision_floating-point_format

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b00111110, 0b00100000, 0b00000000, 0b00000000 ]
    );

    is($val, 0.15625, '... 0.15625 decoded as expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b00111111, 0b10000000, 0b00000000, 0b00000000 ]
    );

    is($val, 1.0, '... 1.0 decoded as expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b00000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, 0.0, '... 0.0 decoded as expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b10000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, -0.0, '... -0.0 decoded as expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b11000000, 0b00000000, 0b00000000, 0b00000000 ]
    );

    is($val, -2.0, '... -2.0 decoded as expected');
}

{
    my ($val, $len) = Muesli::Decoder::decode(
        [ MAGIC_HEADER, FLOAT, 0b01000001, 0b11001000, 0b00000000, 0b00000000 ]
    );

    is($val, 25, '... 25 decoded as expected');
}

# string

{
    my $val = Muesli::Decoder::decode( 
        [ 
            MAGIC_HEADER,      # header
            STRING,            # tag
            0b00001000,        # length 
            (                  # codepoints
                0b01100110,             # f
                0b01100001,             # a
                0b01100011,             # c 
                0b10100111, 0b00000110, # \x{0327}
                0b01100001,             # a
                0b01100100,             # d
                0b01100101,             # e
            )
        ],
    );

    is($val, "fac\x{0327}ade", '... our binary data is fac\x{0327}ade');
}

# undef 

{
    my $val = Muesli::Decoder::decode( [ MAGIC_HEADER, UNDEF ] );

    is($val, undef, '... our data is undef');
}

# array 

{
    my $val = Muesli::Decoder::decode( 
        [ 
            MAGIC_HEADER,    # header        
            ARRAY,           # tag
            0b00001010,      # length 
            (                # elements
                (VARINT, 0b00000001),             # 1
                (VARINT, 0b10101100, 0b00000010), # 300 
                (ZIGZAG, 0b00000001),             # -1
                (ZIGZAG, 0b11010111, 0b00000100), # -300
            )
        ],
    );

    is_deeply($val, [ 1, 300, -1, -300 ], '... our binary data is [ 1, 300, -1, -300 ] as expected');
}

done_testing;