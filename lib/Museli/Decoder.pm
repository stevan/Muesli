package Museli::Decoder;

use strict;
use warnings;

use Museli::Util::Converters;
use Museli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode_int {
    my $idx   = $_[0];
    my $bytes = $_[1];

    die '[BAD INT] Missing the VARINT tag, instead found ' . (sprintf "%x" => $bytes->[ $idx ])
        if $bytes->[ $idx ] != VARINT;

    $idx++;

    my $count = 0; # bit-shift counter
    my $bits  = 0; # int to lay our bit patterns on

    for ( my $i = $idx; $i <= scalar @$bytes; $i++ ) {
        my $b = $bytes->[ $i ];
        $bits |= ( $b & 0x7f ) << $count;
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

    die '[BAD FLOAT] Missing the FLOAT tag, instead found ' . (sprintf "%x" => $bytes->[ $idx ])
        if $bytes->[ $idx ] != FLOAT;   

    $idx++; 

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
    my $idx   = $_[0];
    my $bytes = $_[1];

    die '[BAD STRING] Missing the STRING tag, instead found ' . (sprintf "%x" => $bytes->[ $idx ])
        if $bytes->[ $idx ] != STRING;  

    $idx++;

    my $length;
    ($length, $idx) = decode_int( $idx, $bytes );

    my @cps;
    while ( $idx <= $#{$bytes} ) {
        ($cps[ scalar @cps ], $idx) = decode_int( $idx, $bytes );
        last if scalar @cps == $length;
    }

    return pack('U*', @cps), $idx;
}

1;

__END__