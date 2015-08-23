package Museli::Util::Converters;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our @EXPORT = qw(
    as_byte
    as_int32

    int32_to_varint
    int32_to_zigzag

    varint_to_int32
    zigzag_to_int32
);

sub import {
    my $from    = shift;
    my $to      = caller;
    my @imports = @_ || @EXPORT;

    no strict 'refs';
    foreach my $i ( @imports ) {
        *{ $to . '::' . $i } = \&{ $from .'::'. $i };
    }
}

## ----------------------------------------------
## Simple conversions to native data types
## ----------------------------------------------

sub as_byte  { $_[0] & 0xff     }
sub as_int32 { $_[0] & 0xffffff }

## ----------------------------------------------
## Conversions from native to encoded data types
## ----------------------------------------------

sub int32_to_varint {
    my $int = $_[0];
    my @bytes;
    while ( $int >= 0x80 ) {
        my $b = ( $int & 0x7f ) | 0x80;
        push @bytes => $b;
        $int >>= 7;
    }
    push @bytes => $int;
    return @bytes;    
}

sub varint_to_int32 {
    my $idx   = $_[0];
    my $bytes = $_[1];

    my $count = 0; # bit-shift counter
    my $bits  = 0; # int to lay our bit patterns on

    for ( my $i = $idx; $i <= scalar @$bytes; $i++ ) {
        my $b = $bytes->[ $i ];
        $bits |= ( $b & 0x7f ) << $count;
        $count += 7;

        if (( $b & 0x80 ) == 0) {
            return $bits, ($i + 1);
        }
        
        die '[BAD INT] too many continuation bits'
            if $count > 63;
    }

    die '[BAD INT] missing continuation bits';
}

# zigzag

sub int32_to_zigzag {
    my $int = $_[0];
    return as_int32(($int << 1) ^ ($int >> 31));
}

sub zigzag_to_int32 {
    my $bits = $_[0];
    return -(1 + (as_int32($bits) >> 1) );
}

1;

__END__
