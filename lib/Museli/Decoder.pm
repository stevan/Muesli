package Museli::Decoder;

use strict;
use warnings;

use Museli::Util;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode_int {
    my @bytes = @_;

    my $count = 0; # counter
    my $bits  = 0; # int to lay our bit patterns on

    foreach my $i ( 0 .. @bytes ) {
        my $b = $bytes[$i];
        $bits |= to_byte( $b ) << $count;
        $count += 7;

        if ( ( $b & 0x80 ) == 0 ) {
            return $bits, $i+1;
        }

        if ( $count > 63 ) {
            die '[BAD INT] too many continuation bits';
        }
    }

    die '[BAD INT] missing continuation bits';
}

sub decode_float {
    my @bytes = @_;

    die '[BAD FLOAT] A float must be exact 4 bytes'
        if scalar @bytes != 4;

    my $bits = 0; # int to lay our bit pattersn on

    $bits |= $bytes[0];
    $bits |= $bytes[1] << 8;
    $bits |= $bytes[2] << 16;
    $bits |= $bytes[3] << 24;

    return unpack('f', pack('N', $bits)), 4; # length is always 4
}

1;

__END__