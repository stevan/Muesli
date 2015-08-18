package Museli::Util;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our @EXPORT = qw(
    to_byte
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

sub to_byte { $_[0] & 0x7f }

1;

__END__