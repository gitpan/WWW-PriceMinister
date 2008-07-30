use strict;
use warnings;
use Test::More;
use WWW::PriceMinister;

use t::Util;

plan skip_all => 'No web access' if !web_ok();

# some items that may have associated offers
my @items = (
    255928,      # W Ou Le Souvenir D'enfance
    343943,      # Le Langage C - C Ansi
    884023,      # Alice's Adventures In Wonderland
    46634253,    # L'élégance Du Hérisson
    46661315,    # Millénium Tome 1 - Les Hommes Qui N'aimaient Pas Les Femmes
);

my $pm = WWW::PriceMinister->new();

# fetch a WWW::PriceMinister::Item object with at least 2 offers
( my $item, @items ) = sort { @{ $a->{offers} } <=> @{ $b->{offers} } }
    grep { $_->{offers} }
    map  { $pm->fetch_item($_) } @items;

plan skip_all => 'No offer available for any of the selected items' if !$item;

$item = shift @items while @items && @{ $item->{offers} } <= 1;

plan tests => 9 * @{ $item->{offers} };

# check the offers
for my $o ( @{ $item->{offers} } ) {
    my $offer = $pm->fetch_offer( $o->{aid} );
    isa_ok( $offer, 'WWW::PriceMinister::Offer' );
    is_deeply(
        [ sort keys %$offer ],
        [qw( aid comment condition id price savings seller title )],
        "All offer keys present for offer $offer->{aid}"
    );
    is( $offer->{title}, $item->{title}, "title = $item->{title}" );
    is( $offer->{id},    $item->{id},    "id = $item->{id}" );
    like( $offer->{aid},   qr/^\d+$/,      "aid = $offer->{aid}" );
    like( $offer->{price}, qr/^\d+\.\d+$/, "price = $offer->{price}" );
    like( $offer->{savings}, qr/^(?:\d+\s*%|$)/,
        "savings = $offer->{savings}" );
    like(
        $offer->{condition},
        qr/^(?:(?:(?:Très )?Bon Eta|Etat Correc)t|(?:Comme|Produit) Neuf)$/,
        "condition = $offer->{condition}"
    );
    isa_ok( $offer->{seller}, 'WWW::PriceMinister::Seller' );
}

