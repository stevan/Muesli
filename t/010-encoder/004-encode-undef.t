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
    FORMAT_BINARY(Muesli::Encoder::encode_undef()),
    FORMAT_BINARY(UNDEF),
    '... undef encoded as expected'
);

done_testing;
