package WWW::PriceMinister::Offer;

use strict;
use warnings;

use WWW::PriceMinister::Seller;
use WWW::PriceMinister::Item;
our @ISA = qw( WWW::PriceMinister::Item );

1;

sub _update_from_tree {
    my ( $self, $tree ) = @_;

    # we can fetch some information from the Item methods
    $self->SUPER::_update_from_tree($tree);

    my $offer = $tree->look_down( _tag => 'td', id => 'fpaction_topright' );

    # compute the item id
    ( $self->{id} ) = $tree->as_HTML =~ /productid=(\d+)/g;

    # our offer id
    $self->{aid} = $tree->look_down( _tag => 'form', action => '/cart' )
        ->look_down( _tag => 'input', name => 'aid' )->attr('value');

    # condition & comment
    @{$self}{qw( condition comment )}
        = map { ref $_ ? $_->as_trimmed_text : $self->trim_text($_) }
        $offer->look_down( _tag => 'p', class => 'comment' )->content_list();

    # price & savings
    $self->{price} = $self->format_price(
        $offer->look_down(
            _tag  => 'span',
            name  => 'advert_price',
            class => qr/price/
            )->as_trimmed_text
    );
    $self->{savings} = eval {
        $offer->look_down( _tag => 'span', class => 'f11' )->as_trimmed_text;
    } || '';

    # seller
    ( $self->{seller} = WWW::PriceMinister::Seller->new() )
        ->_update_from_tree($tree);
}

__END__

=head1 NAME

WWW::PriceMinister::Offer - An actuall offer for an item on Price Minister

=head1 SYNOPSIS

    use WWW::PriceMinister;

    # Programming Perl - 3rd ed
    my $item = WWW::PriceMinister->new()->fetch_item( 883778 );
    my @offers  = $item->offers();

=head1 DESCRIPTION

C<WWW::PriceMinister::Offer> represents an offer for an item on the
PriceMinister online store.

It is a subclass of C<WWW::PriceMinister::Item>.

=head1 METHODS

C<WWW::PriceMinister::Offer> inherits the following methods from
C<WWW::PriceMinister::Object>:

=over 4

=item new( %params )

=item new_from_content( $content )

=back

=head1 AUTHOR

Philippe Bruhat (BooK), C<< <book@cpan.org> >>.

=head1 COPYRIGHT 

Copyright 2008 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

