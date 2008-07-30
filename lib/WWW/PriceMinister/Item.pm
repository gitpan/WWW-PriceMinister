package WWW::PriceMinister::Item;

use strict;
use warnings;
use HTML::TreeBuilder;
use WWW::PriceMinister::Object;
use WWW::PriceMinister::Offer;
use WWW::PriceMinister::Seller;

our @ISA = qw( WWW::PriceMinister::Object );

1;

sub _update_from_tree {
    my ( $self, $tree ) = @_;

    # id
    ( $self->{id} )
        = $tree->as_HTML =~ m{this.location.href ='/offer/buy/(\d+)/}g;

    # get as many attributes as possible
    $self->{title}
        = $tree->look_down( _tag => 'h1' )->look_down( _tag => 'a' )
        ->as_trimmed_text;

    # compute offers
    for my $o ( $tree->look_down( _tag => 'div', class => 'p_right' ) ) {
        my $offer = WWW::PriceMinister::Offer->new( map { $_ => $self->{$_} }
                qw( title id ) );
        $offer->{price} = $self->format_price(
            $o->look_down( _tag => 'span', class => qr/price/ )->as_text );
        $offer->{seller}
            = WWW::PriceMinister::Seller->new(
            id => $o->look_down( _tag => 'a', class => 'fp_seller' )
                ->as_trimmed_text );
        $offer->{condition}
            = $o->look_down( _tag => 'span', class => qr/advtype_/ )
            ->as_trimmed_text;
        ( $offer->{aid} )
            = $o->as_HTML =~ /offer\?action=desc&amp;aid=(\d+)/g;
        push @{ $self->{offers} }, $offer;
    }
}

__END__

=head1 NAME

WWW::PriceMinister::Item - A sellable item on Price Minister

=head1 SYNOPSIS

    use WWW::PriceMinister;

    # Programming Perl - 3rd ed
    my $item = WWW::PriceMinister->new()->fetch_item( 883778 );

=head1 DESCRIPTION

C<WWW::PriceMinister::Item> represents an item in the Price Minister
store.

=head1 METHODS

C<WWW::PriceMinister::Item> inherits the following methods from
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

