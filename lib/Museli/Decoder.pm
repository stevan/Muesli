package Museli::Decoder;

use strict;
use warnings;

use Museli::Util;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode_int {
    my $idx   = $_[0];
    my $bytes = $_[1];

    my $count = 0; # counter
    my $bits  = 0; # int to lay our bit patterns on

    for ( my $i = $idx; $i <= scalar @$bytes; $i++ ) {
        my $b = $bytes->[ $i ];
        $bits |= to_byte( $b ) << $count;
        $count += 7;

        return $bits, ($i + 1)
            if ( $b & 0x80 ) == 0;

        die '[BAD INT] too many continuation bits'
            if $count > 63;
    }

    die '[BAD INT] missing continuation bits';
}

sub decode_float {
    my $idx   = $_[0];
    my $bytes = $_[1];

    die '[BAD FLOAT] A float must be at least 4 bytes long, got truncated data'
        unless ($idx + 3) >= $#{$bytes};

    my $bits = 0; # int to lay our bit patterns on
    $bits |= $bytes->[ $idx    ]      ;
    $bits |= $bytes->[ $idx + 1] <<  8;
    $bits |= $bytes->[ $idx + 2] << 16;
    $bits |= $bytes->[ $idx + 3] << 24;

    return unpack('f', pack('N', $bits)), ($idx + 4); # length is always 4
}

sub decode_string {
    my $idx    = $_[0];
    my $bytes  = $_[1];

    my @cps;
    do {
        ($cps[ scalar @cps ], $idx) = decode_int( $idx, $bytes );
    } while $idx <= $#{$bytes};

    return pack('U*', @cps), $idx;
}

1;

__END__