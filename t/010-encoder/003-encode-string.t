#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Encoder');
}

use Muesli::Util::Devel qw[ FORMAT_BINARY ];
use Muesli::Util::Constants;

# http://docstore.mik.ua/orelly/perl4/cook/ch01_05.htm

is( 
    FORMAT_BINARY(Muesli::Encoder::encode_string( "façade" )),
    (join ' ' => 
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

done_testing;
