package Muesli;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Muesli::Encoder;
use Muesli::Decoder;

BEGIN {
    *encode = \&Muesli::Encoder::encode;
    *decode = \&Muesli::Decoder::decode;
}

1;

__END__
