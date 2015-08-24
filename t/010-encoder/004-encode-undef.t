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
    bin_fmt(Muesli::Encoder::encode_undef()),
    bin_fmt(UNDEF),
    '... undef encoded as expected'
);

done_testing;
