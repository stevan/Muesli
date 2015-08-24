package Muesli::Encoder;

use strict;
use warnings;

use B;
use Scalar::Util qw[ 
    reftype
    blessed 
    looks_like_number 
];

use Muesli::Util::Devel;
use Muesli::Util::Converters;
use Muesli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode { 
    return (MAGIC_HEADER, encode_data( @_ ));
}

sub encode_data {
    my ($data) = @_;

    my @bytes;

    if ( not defined $data ) {
        LOG(INFO => 'Encoding UNDEF') if DEBUG;
        push @bytes => encode_undef( $data );
    }
    elsif ( ref $data ) {
        LOG(INFO => 'Encoding a ref') if DEBUG;

        die '[PANIC] Currently blessed items are not supported'
            if blessed $data;

        my $type = reftype $data;
        if ( $type eq 'ARRAY' ) {
            LOG(INFO => 'Encoding ARRAY ref') if DEBUG;
            push @bytes => encode_array( $data );
        }
        elsif ( $type eq 'HASH' ) {
            LOG(INFO => 'Encoding HASH ref') if DEBUG;
            push @bytes => encode_hash( $data );
        }
        else {
            LOG(FATAL => 'Attempting to encode an unsupported reftype %s', $type) if DEBUG;
            die '[PANIC] Currently items of type(' . $type . ') are not supported'
        }
    }
    else { 
        LOG(INFO => 'Encoding a non-ref') if DEBUG;

        my $flags = B::svref_2object(\$data)->FLAGS;

        if (( $flags & B::SVp_IOK ) == B::SVp_IOK ) {
            LOG(INFO => 'Encoding INT') if DEBUG;
            push @bytes => encode_int( $data );
        }
        elsif (( $flags & B::SVp_NOK ) == B::SVp_NOK ) {
            LOG(INFO => 'Encoding FLOAT') if DEBUG;
            push @bytes => encode_float( $data );
        }
        elsif (( $flags & B::SVp_POK ) == B::SVp_POK ) {
            LOG(INFO => 'Encoding STRING') if DEBUG;
            push @bytes => encode_string( $data );
        }
        else {
            LOG(FATAL => 'Attempting to encode an unsupported value type %s', $flags) if DEBUG;
            die '[PANIC] Currently scalars with the following flags (' . $flags . ') are not supported'
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