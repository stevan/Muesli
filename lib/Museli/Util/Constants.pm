package Museli::Util::Constants;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our @EXPORT = qw(
    MAGIC_HEADER
    
    INT   
    FLOAT 
    STRING
    UNDEF 
    HASH  
    ARRAY 
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

## --------------------------

sub MAGIC_HEADER () { (0x3d, 0x6d, 0x73, 0x6c) } # =msl

=pod
                  Tag |  Hex |     Binary | Follow
    ------------------+------+----------- |-----------------------------------------
    VARINT            | 0x20 | 0b00100000 | <VARINT> - Varint variable length integer
    FLOAT             | 0x22 | 0b00100010 | <IEEE-FLOAT>
    STR_UTF8          | 0x27 | 0b00100111 | <LEN-VARINT> <UTF8> - utf8 string
    UNDEF             | 0x25 | 0b00100101 | None - Perl undef var; eg my $var= undef;
    HASH              | 0x2a | 0b00101010 | <COUNT-VARINT> [<KEY-TAG> <ITEM-TAG> ...] - count followed by key/value pairs
    ARRAY             | 0x2b | 0b00101011 | <COUNT-VARINT> [<ITEM-TAG> ...] - count followed by items
=cut

sub INT          () { 0x20 } # 0b00100000
sub FLOAT        () { 0x22 } # 0b00100010
sub STRING       () { 0x27 } # 0b00100111
sub UNDEF        () { 0x25 } # 0b00100101
sub HASH         () { 0x2a } # 0b00101010
sub ARRAY        () { 0x2b } # 0b00101011

1;

__END__
