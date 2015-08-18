package Museli::Encoder;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode_varint {
    my $int = $_[0];
    my @bytes;
    while ( $int >= 0x80 ) {
        my $b = ( $int & 0x7f ) | 0x80;
        push @bytes => $b;
        $int >>= 7;
    }
    push @bytes => $int;
    return @bytes;
}

1;

__END__