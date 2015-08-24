package Muesli::Encoder;

use strict;
use warnings;

use B;
use Scalar::Util qw[ 
    reftype
    blessed 
    looks_like_number 
];

use Muesli::Util::Converters;
use Muesli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode {
    my ($data) = @_;

    my @bytes = (MAGIC_HEADER);

    if ( ref $data ) {

        die '[PANIC] Currently blessed items are not supported'
            if blessed $data;

        my $type = reftype $data;
        if ( $type eq 'ARRAY' ) {
            push @bytes => encode_array( $data );
        }
        elsif ( $type eq 'HASH' ) {
            push @bytes => encode_hash( $data );
        }
        else {
            die '[PANIC] Currently items of type(' . $type . ') are not supported'
        }
    }
    else { 
        if ( looks_like_number( $data ) ) {
            if ( B::svref_2object( \$data )->isa('B::NV') ) { # is a float?
                push @bytes => encode_float( $data );
            }
            else {
                push @bytes => encode_int( $data );
            }
        }
        else {
            push @bytes => encode_string( $data );
        }
    }
    
    return @bytes;
}

sub encode_array {

}

sub encode_hash {

}

sub encode_undef { return (UNDEF) }

sub encode_int {
    my $int   = $_[0];
    my @bytes;
    if ( $int < 0 ) {
        push @bytes => ZIGZAG;
        $int = int32_to_zigzag( $int );
    }
    else {
        push @bytes => VARINT;
    }
    push @bytes => int32_to_varint($int);
    return @bytes;
}

sub encode_float {
    my $float = $_[0];
    my @bytes = (FLOAT); # tag byte ...
    my $u = unpack('N', pack('f', $float));
    push @bytes => as_byte( $u       );
    push @bytes => as_byte( $u >>  8 );
    push @bytes => as_byte( $u >> 16 );
    push @bytes => as_byte( $u >> 24 );
    return @bytes;
}

sub encode_string {
    my $string  = $_[0];
    my @encoded = map int32_to_varint( $_ ), unpack("U*", $string);
    my @bytes   = (STRING); # tag byte ...    
    push @bytes => int32_to_varint( scalar @encoded );
    push @bytes => @encoded;
    return @bytes;
}

1;

__END__