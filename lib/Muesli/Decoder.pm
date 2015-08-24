package Muesli::Decoder;

use strict;
use warnings;

use Muesli::Util::Devel;
use Muesli::Util::Converters;
use Muesli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub decode {
    my $bytes = $_[0];
    my $idx   = 0;
    my $value;

    return $value;
}

sub decode_array {
    my $idx   = $_[0];
    my $bytes = $_[1];
}

sub decode_hash {
    my $idx   = $_[0];
    my $bytes = $_[1];
}

sub decode_undef {
    my $idx   = $_[0];
    my $bytes = $_[1];
    my $tag   = $bytes->[ $idx ];

    die '[BAD TAG] Missing the UNDEF tag, instead found ' . (sprintf "%x" => $tag)
        if $tag != UNDEF;    

    return (undef, $idx + 1);
}

sub decode_int {
    my $idx   = $_[0];
    my $bytes = $_[1];
    my $tag   = $bytes->[ $idx ];

    die '[BAD TAG] Missing the VARINT or ZIGZAG tags, instead found ' . (sprintf "%x" => $tag)
        if $tag != VARINT
        && $tag != ZIGZAG;

    $idx++;

    my $bits = 0;
    ($bits, $idx) = varint_to_int32( $idx, $bytes );
    $bits = zigzag_to_int32($bits) if $tag == ZIGZAG;
    return ($bits, $idx);
}

sub decode_float {
    my $idx   = $_[0];
    my $bytes = $_[1];

    die '[BAD TAG] Missing the FLOAT tag, instead found ' . (sprintf "%x" => $bytes->[ $idx ])
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

    die '[BAD TAG] Missing the STRING tag, instead found ' . (sprintf "%x" => $bytes->[ $idx ])
        if $bytes->[ $idx ] != STRING;  

    $idx++;

    my $length;
    ($length, $idx) = varint_to_int32( $idx, $bytes );

    my @cps;
    while ( $idx <= $#{$bytes} ) {
        ($cps[ scalar @cps ], $idx) = varint_to_int32( $idx, $bytes );
        last if scalar @cps == $length;
    }

    return pack('U*', @cps), $idx;
}

1;

__END__