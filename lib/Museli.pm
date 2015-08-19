package Museli;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

1;

__END__

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