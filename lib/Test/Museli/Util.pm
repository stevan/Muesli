package Test::Museli::Util;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our @EXPORT = qw(
    bin_fmt
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

sub bin_fmt { join ' ' => map { sprintf '%08b' => $_ } @_ }

1;

__END__