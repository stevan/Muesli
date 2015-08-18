package Museli::Decoder;

use strict;
use warnings;

use Museli::Util;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode_int {
    my ($idx, $bytes, %opts) = @_;

    my $count = 0; # bit-shift counter
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
    my ($idx, $bytes, %opts) = @_;

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
    my ($idx, $bytes, %opts) = @_;

    my @cps;
    while ( $idx <= $#{$bytes} ) {
        
        ($cps[ scalar @cps ], $idx) = decode_int( $idx, $bytes );

        last if $opts{num_code_points} && scalar @cps == $opts{num_code_points};
    }

    return pack('U*', @cps), $idx;
}

1;

__END__