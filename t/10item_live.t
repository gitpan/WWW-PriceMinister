use strict;
use warnings;
use Test::More;
use WWW::PriceMinister;

use t::Util;

plan skip_all => 'No web access' if !web_ok();

my @tests = (

    # id, result
    [undef],
    ['abc'],
    [999999999],
    [ 883778 => WWW::PriceMinister::Item->new( flesh('wall') ) ]
);

plan 'no_plan';

my $pm = WWW::PriceMinister->new();

for my $t (@tests) {
    my ( $id, $expected ) = @$t;

    my $item = $pm->fetch_item($id);
    if ( !$expected ) {
        $id = '<undef>' if !defined $id;
        is( $item, undef, "No item found with id $id" );
    }
    else {

        # ignore offers for now
        my $offers = delete $item->{offers};
        is_deeply( $item, $expected, "$expected->{title}" );

        # now test the offers
        if ($offers) {
            for my $o (@$offers) {
                isa_ok( $o, 'WWW::PriceMinister::Offer' );
                is_deeply(
                    [ sort keys %$o ],
                    [qw( aid condition id price seller title )],
                    'All offer keys present'
                );
                is( $o->{id}, $item->{id},
                    "offer id for $expected->{title}" );
                is( $o->{title}, $item->{title},
                    "offer title for $expected->{title}" );
                like( $o->{aid}, qr/^\d+$/,
                    "offer aid for $expected->{title}" );
                like( $o->{price}, qr/^\d+\.\d+$/,
                    "offer price for $expected->{title}" );
                isa_ok( $o->{seller}, 'WWW::PriceMinister::Seller' );
                like( $o->{seller}{id},
                    qr/^\w+$/, "offer seller for $expected->{title}" );
                like(
                    $o->{condition},
                    qr/(?:(?:(?:Très )?Bon Eta|Etat Correc)t|Comme Neuf)$/,
                    "offer condition for $expected->{title}"
                );
            }
        }
    }
}

