package Muesli::Util::Devel;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

our @EXPORT = qw(
    LOG
    DEBUG
);

sub import {
    my $from    = shift;
    my $to      = caller;
    my @imports = @_ ? @_ : @EXPORT;

    no strict 'refs';
    foreach my $i ( @imports ) {
        *{ $to . '::' . $i } = \&{ $from .'::'. $i };
    }
}

## --------------------------

sub DEBUG () { $ENV{MUESLI_DEBUG} // 0 }

sub LOG {
    my ($level, $msg, @args) = @_;
    warn sprintf "[%s] [%s] %s - $msg" => $$, scalar localtime, $level, @args;
}

sub FORMAT_BINARY { join ' ' => map { sprintf '%08b' => $_ } @_ }

1;

__END__
