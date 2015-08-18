package Museli::Encoder;

use strict;
use warnings;

use Museli::Util;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub encode_int {
    my $int = $_[0];
    my @bytes;
    while ( $int >= 0x80 ) {
        my $b = to_byte( $int ) | 0x80;
        push @bytes => $b;
        $int >>= 7;
    }
    push @bytes => $int;
    return @bytes;
}

sub encode_float {
    my $float = $_[0];
    my @bytes;
    my $u = unpack('N', pack('f', $float));
    push @bytes => to_byte( $u       );
    push @bytes => to_byte( $u >>  8 );
    push @bytes => to_byte( $u >> 16 );
    push @bytes => to_byte( $u >> 24 );
    return @bytes;
}

sub encode_string {
    my $string = $_[0];
    my @bytes  = map encode_int( $_ ), unpack("U*", $string);
    return @bytes;
}

1;

__END__