package Museli::Decoder;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode_varint {
    my @bytes = @_;

    my $s = 0; # counter
    my $n = 0; # int to lay our bit patterns on

    foreach my $i ( 0 .. @bytes ) {
        my $b = $bytes[$i];
        $n |= ( $b & 0x7f ) << $s;
        $s += 7;

        if ( ( $b & 0x80 ) == 0 ) {
            return $n, $i+1;
        }

        if ( $s > 63 ) {
            die '[BAD VARINT] too many continuation bits';
        }
    }

    die '[BAD VARINT] missing continuation bits';
}

1;

__END__