=head1 NAME

Util::IO - sysread/syswrite wrappers reliable on EAGAIN

=cut
package Util::IO;

=head1 VERSION

This documentation describes version 0.01

=cut
use version;      our $VERSION = qv( 0.01 );

use warnings;
use strict;

use Errno qw( :POSIX );

use constant { MAX_BUF => 2 ** 10 };

=head1 SYNOPSIS

 use Util::IO;

 ## see sysread and syswrite for parameter
 my $read = Util::IO->read( $socket, $buffer, 1024 );
 my $written = Util::IO->write( $socket, $buffer );

=head1 DESCRIPTION

=head2 read

See sysread().

=cut
sub read
{
    my $class = shift;
    my ( $offset, $length ) = ( 0, $_[2] );

    while ( ! $length || $offset < $length )
    {
        my $limit = $length ? $length - $offset : MAX_BUF;
        my $length = sysread $_[0], $_[1], $limit, $offset;

        if ( defined $length )
        {
            last unless $length;
            $offset += $length;
        }
        elsif ( $! != EAGAIN )
        {
            return undef;
        }
    }

    return $offset;
}

=head2 write

See syswrite().

=cut
sub write
{
    my $class = shift;
    my ( $offset, $length ) = ( 0, length $_[1] );

    while ( $offset < $length )
    {
        my $length = syswrite $_[0], $_[1], MAX_BUF, $offset;

        if ( defined $length )
        {
            $offset += $length;
        }
        elsif ( $! != EAGAIN )
        {
            return undef;
        }
    }

    return $offset;
}

=head1 AUTHOR

Kan Liu

=head1 COPYRIGHT and LICENSE

Copyright (c) 2010. Kan Liu

This program is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

__END__

