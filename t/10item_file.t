use strict;
use warnings;
use Test::More;
use WWW::PriceMinister::Item;
use WWW::PriceMinister::Offer;
use WWW::PriceMinister::Seller;

use t::Util;

my @tests = (

    # file, result
    [],
    [   't/html/item-wall.html' => WWW::PriceMinister::Item->new(
            flesh('wall'),
            offers => [
                WWW::PriceMinister::Offer->new(
                    flesh('wall'),
                    price => '25.50',
                    seller =>
                        WWW::PriceMinister::Seller->new( id => 'iske2003' ),
                    condition => 'Très Bon Etat',
                    aid       => '115079519',
                ),
            ],
        )
    ],
    [   't/html/item-larsson.html' => WWW::PriceMinister::Item->new(
            flesh('larsson'),
            offers => [
                map {
                    WWW::PriceMinister::Offer->new( flesh('larsson'), @$_ )
                    } (
                    [   price  => '15.90',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'sophiedaix'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '173530323',
                    ],
                    [   price => '16.00',
                        seller =>
                            WWW::PriceMinister::Seller->new( id => 'rzogue' ),
                        condition => 'Comme Neuf',
                        aid       => '173458042',
                    ],
                    [   price  => '16.70',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'Videntes'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '171670876',
                    ],
                    [   price  => '16.90',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'KALITEPRIX'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '165110847',
                    ],
                    [   price  => '16.95',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'bertrand74'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '171170854',
                    ],
                    [   price => '17.00',
                        seller =>
                            WWW::PriceMinister::Seller->new( id => 'erryka' ),
                        condition => 'Comme Neuf',
                        aid       => '173654779',
                    ],
                    [   price  => '17.50',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'loizirs'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '171831093',
                    ],
                    [   price  => '17.95',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'lilamely93'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '167911556',
                    ],
                    [   price  => '18.00',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'kressbleu'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '169351957',
                    ],
                    [   price  => '18.00',
                        seller => WWW::PriceMinister::Seller->new(
                            id => 'prevostiere'
                        ),
                        condition => 'Comme Neuf',
                        aid       => '165815630',
                    ],
                    )
            ],
        )
    ]
);

plan tests => scalar @tests;

for my $t (@tests) {
    my ( $file, $expected ) = @$t;
    my $content;
    if ($file) { local $/; local @ARGV = $file; $content = <> }
    my $item = WWW::PriceMinister::Item->new_from_content($content);
    is_deeply( $item, $expected,
        $expected ? $expected->{title} : 'empty file' );
}

