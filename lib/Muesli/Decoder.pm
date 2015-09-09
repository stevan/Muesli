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

    my @header = MAGIC_HEADER();

    my $idx;
    for ( $idx = 0; $idx < $#header; $idx++ ) {
        die '[BAD HEADER] Unable to match the magic header to the start of the byte array'
            unless $bytes->[ $idx ] == $header[ $idx ]
    }

    $idx++;

    (my $value, $idx) = decode_data( $idx, $bytes );

    return $value;
}

sub decode_data {
    my $idx   = $_[0];    
    my $bytes = $_[1];
    my $tag   = $bytes->[ $idx ];

    LOG(INFO => 'Decoding for tag(%08b)' => $tag) if DEBUG;

    if ( $tag == VARINT || $tag == ZIGZAG ) {
        LOG(INFO => 'Decoding an INT') if DEBUG;
        return decode_int( $idx, $bytes );
    }
    elsif ( $tag == FLOAT ) {
        LOG(INFO => 'Decoding a FLOAT') if DEBUG;
        return decode_float( $idx, $bytes );   
    }
    elsif ( $tag == STRING ) {
        LOG(INFO => 'Decoding a STRING') if DEBUG;
        return decode_string( $idx, $bytes );
    }
    elsif ( $tag == UNDEF ) {
        LOG(INFO => 'Decoding a UNDEF') if DEBUG;
        return decode_undef( $idx, $bytes );
    }
    elsif ( $tag == HASH ) {
        LOG(INFO => 'Decoding a HASH') if DEBUG;
        return decode_hash( $idx, $bytes );
    }
    elsif ( $tag == ARRAY ) {
        LOG(INFO => 'Decoding a ARRAY') if DEBUG;
        return decode_array( $idx, $bytes );
    }
    else {
        die '[BAD TAG] I do not recognize this tag (' . (sprintf "%08b" => $tag) . ')'; 
    }
}

sub decode_array {
    my $idx   = $_[0];
    my $bytes = $_[1];
    my $tag   = $bytes->[ $idx ];

    die '[BAD TAG] Missing the ARRAY tag, instead found ' . (sprintf "%x" => $tag)
        if $tag != ARRAY; 

    $idx++;

    (my $length, $idx) = varint_to_int32( $idx, $bytes );

    my @items;
    while ( $idx <= $#{$bytes} ) {
        ($items[ scalar @items ], $idx) = decode_data( $idx, $bytes );
        last if scalar @items == $length;
    }

    return \@items, $idx;    
}

sub decode_hash {
    my $idx   = $_[0];
    my $bytes = $_[1];
    my $tag   = $bytes->[ $idx ];

    die '[BAD TAG] Missing the HASH tag, instead found ' . (sprintf "%x" => $tag)
        if $tag != HASH; 

    $idx++;

    (my $length, $idx) = varint_to_int32( $idx, $bytes );

    my %items;
    while ( $idx <= $#{$bytes} ) {
        (my $key,        $idx) =  decode_string( $idx, $bytes );
        ($items{ $key }, $idx) =  decode_data( $idx, $bytes );
        last if scalar keys %items == $length;
    }

    return \%items, $idx;    
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

    (my $bits, $idx) = varint_to_int32( $idx, $bytes );
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

    (my $length, $idx) = varint_to_int32( $idx, $bytes );

    my $new_idx = $idx + $length;
    my $string  = join "" => map chr, @{ $bytes }[ $idx .. ($new_idx - 1) ];
    utf8::decode($string);

    return $string, $new_idx;
}

1;

__END__