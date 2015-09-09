package Muesli::Encoder;

use strict;
use warnings;

use B;
use Scalar::Util qw[ blessed ];

use Muesli::Util::Devel;
use Muesli::Util::Converters;
use Muesli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode { 
    return [ MAGIC_HEADER, encode_data( @_ ) ];
}

sub encode_data {
    if ( not defined $_[0] ) {
        LOG(INFO => 'Encoding UNDEF') if DEBUG;
        return encode_undef( $_[0] );
    }
    elsif ( ref $_[0] ) {
        LOG(INFO => 'Encoding a ref') if DEBUG;

        die '[PANIC] Currently blessed items are not supported'
            if blessed $_[0];

        my $type = ref $_[0];
        if ( $type eq 'ARRAY' ) {
            LOG(INFO => 'Encoding ARRAY ref') if DEBUG;
            return encode_array( $_[0] );
        }
        elsif ( $type eq 'HASH' ) {
            LOG(INFO => 'Encoding HASH ref') if DEBUG;
            return encode_hash( $_[0] );
        }
        else {
            LOG(FATAL => 'Attempting to encode an unsupported reftype %s', $type) if DEBUG;
            die '[PANIC] Currently items of type(' . $type . ') are not supported'
        }
    }
    else { 
        LOG(INFO => 'Encoding a non-ref') if DEBUG;

        my $flags = B::svref_2object(\$_[0])->FLAGS;

        if (( $flags & B::SVp_IOK ) == B::SVp_IOK ) {
            LOG(INFO => 'Encoding INT') if DEBUG;
            return encode_int( $_[0] );
        }
        elsif (( $flags & B::SVp_NOK ) == B::SVp_NOK ) {
            LOG(INFO => 'Encoding FLOAT') if DEBUG;
            return encode_float( $_[0] );
        }
        elsif (( $flags & B::SVp_POK ) == B::SVp_POK ) {
            LOG(INFO => 'Encoding STRING') if DEBUG;
            return encode_string( $_[0] );
        }
        else {
            LOG(FATAL => 'Attempting to encode an unsupported value type %s', $flags) if DEBUG;
            die '[PANIC] Currently scalars with the following flags (' . $flags . ') are not supported'
        }
    }
}

sub encode_array {
    my @array   = @{ $_[0] };
    my @encoded = map encode_data( $_ ), @array;
    my @bytes   = (ARRAY, int32_to_varint( 0+@array ), @encoded);
    return @bytes;
}

sub encode_hash {
    my @keys    = keys %{ $_[0] };
    my @encoded = map { encode_string( $_ ), encode_data( $_[0]->{ $_ } ) } sort @keys;
    my @bytes   = (HASH, int32_to_varint( 0+@keys ), @encoded);
    return @bytes;
}

sub encode_undef { return (UNDEF) }

sub encode_int {
    my $int = $_[0];
    my @bytes;
    if ( $int < 0 ) {
        @bytes = (ZIGZAG, int32_to_varint( int32_to_zigzag( $int ) ));
    }
    else {
        @bytes = (VARINT, int32_to_varint( $int ));
    }
    return @bytes;
}

sub encode_float {
    my $float = unpack('N', pack('f', $_[0]));
    my @bytes = (
        FLOAT, # tag byte ...
        as_byte( $float       ),
        as_byte( $float >>  8 ),
        as_byte( $float >> 16 ),
        as_byte( $float >> 24 ),
    );
    return @bytes;
}

sub encode_string {
    my @encoded = map ord, split '' => $_[0];
    my @bytes   = (STRING, int32_to_varint( 0+@encoded ), @encoded);
    return @bytes;
}

1;

__END__