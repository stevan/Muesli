package Museli::Encoder;

use strict;
use warnings;

use Scalar::Util qw[ 
    reftype
    blessed 
    looks_like_number 
];

use Museli::Util::Converters;
use Museli::Util::Constants;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode {
    my $data = @_;

    my @bytes;
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
            if ( int($data) == $data ) {
                push @bytes => encode_int( $data );
            }
            else {
                push @bytes => encode_float( $data );
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

sub encode_int {
    my $int   = $_[0];
    my @bytes = (INT); # tag byte ...
    while ( $int >= 0x80 ) {
        my $b = ( $int & 0x7f ) | 0x80;
        push @bytes => $b;
        $int >>= 7;
    }
    push @bytes => $int;
    return @bytes;
}

sub encode_float {
    my $float = $_[0];
    my @bytes = (FLOAT); # tag byte ...
    my $u = unpack('N', pack('f', $float));
    push @bytes => to_byte( $u       );
    push @bytes => to_byte( $u >>  8 );
    push @bytes => to_byte( $u >> 16 );
    push @bytes => to_byte( $u >> 24 );
    return @bytes;
}

sub encode_string {
    my $string  = $_[0];
    my @encoded = map encode_int( $_ ), unpack("U*", $string);
    my @bytes   = (STRING); # tag byte ...    
    push @bytes => encode_int( scalar @encoded );
    push @bytes => @encoded;
    return @bytes;
}

1;

__END__