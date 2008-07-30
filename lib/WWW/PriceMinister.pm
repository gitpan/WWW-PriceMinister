package WWW::PriceMinister;

use warnings;
use strict;
use Carp qw( croak );
use WWW::Mechanize;

use WWW::PriceMinister::Item;
use WWW::PriceMinister::Offer;
use WWW::PriceMinister::Seller;

our $VERSION = '0.01';

my $base    = 'http://www.priceminister.com';
my %url_for = (
    Item   => "$base/offer/buy/%s/sort0/all",
    Offer  => "$base/offer?action=desc&aid=%s",
    Seller => "$base/boutique/%s",
);

for my $object ( keys %url_for ) {
    no strict 'refs';
    *{ lc "fetch_$object" } = sub { shift->fetch( $object => @_ ) };
}

1;

sub new {
    my ( $class, %args ) = @_;
    my $self = {
        agent => WWW::Mechanize->new(
            agent       => __PACKAGE__ . '/' . $VERSION,
            stack_depth => 1,
        ),
        %args,
    };

    return bless $self, $class;
}

sub fetch {
    my ( $self, $object, $id ) = @_;

    # basic failures
    croak "Can't fetch unknown PriceMinister object '$object'"
        if !exists $url_for{ $object ||= '' };
    return if !$id;

    # fetch the content
    my $m = $self->{agent};
    $m->get( sprintf( $url_for{$object}, $id ) );
    return if !$m->success;

    # create the object
    return "WWW::PriceMinister::$object"->new_from_content( $m->content );
}

__END__

=head1 NAME

WWW::PriceMinister - A Perl interface to the PriceMinister web site

=head1 SYNOPSIS

    use WWW::PriceMinister;

    my $pm = WWW::PriceMinister->new();

=head1 DESCRIPTION

=head1 METHODS

C<WWW::PriceMinister> provides the following methods:

=over 4

=item new( %args )

Return a new C<WWW::PriceMinister> object.

=item fetch( $object => $id )

Return a C<WWW::PriceMinister::$object> object, corresponding to the
given C<$id>, and fecthed from the PriceMinister web site.

=item fetch_item( $id )

Shortcut for C<< fetch( Item => $id ) >>.

=item fetch_offer( $id )

Shortcut for C<< fetch( Offer => $id ) >>.

=item fetch_seller( $id )

Shortcut for C<< fetch( Seller => $id ) >>.

=back

=head1 AUTHOR

Philippe Bruhat (BooK), C<< <book@cpan.org> >>.

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-priceminister at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-PriceMinister>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::PriceMinister

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-PriceMinister>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-PriceMinister>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-PriceMinister>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-PriceMinister>

=back

=head1 COPYRIGHT 

Copyright 2008 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

