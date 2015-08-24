#!perl 

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('Muesli::Decoder');
}

use Muesli::Util::Constants;

{
    my ($val, $size) = Muesli::Decoder::decode_undef( 
        0, 
        [ UNDEF ],
    );

    is($val, undef, '... our data is undef');
    is($size, 1, '... and it took 1 byte');
}

done_testing;