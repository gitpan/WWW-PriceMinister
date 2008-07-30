use strict;
use warnings;
use Test::More;
use t::Util;
use WWW::PriceMinister::Offer;
use WWW::PriceMinister::Seller;

my @tests = (

    # file, result
    [],
    [   't/html/offer-larsson.html' => WWW::PriceMinister::Offer->new(
            flesh('larsson'),
            comment =>
                'livre comme neuf lu une seule fois, la tranche est intacte.',
            condition => 'Comme Neuf',
            savings   => q{30 % d'économie},
            price     => '16.00',
            aid       => '178345749',
            seller    => WWW::PriceMinister::Seller->new(
                id              => 'nanou040568',
                ventes          => 28,
                score           => 4.6,
                acceptance_rate => '88 %',
                member_since    => '14/02/2007',
                last_visit      => '28/07/2008',
                response_time   => '35h 38min',
            ),
        )
    ],
    [   't/html/offer-perec.html' => WWW::PriceMinister::Offer->new(
            flesh('perec'),
            comment   => undef,
            condition => 'Produit Neuf',
            savings   => q{5 % d'économie},
            price     => '7.09',
            aid       => '16507499',
            seller    => WWW::PriceMinister::Seller->new(
                id              => 'manouia',
                ventes          => 871,
                score           => 4.7,
                acceptance_rate => '93 %',
                member_since    => '02/10/2003',
                last_visit      => '29/07/2008',
                response_time   => '14h 59min',
            ),
        )
    ],
);

plan tests => scalar @tests;

for my $t (@tests) {
    my ( $file, $expected ) = @$t;
    my $content;
    if ($file) { local $/; local @ARGV = $file; $content = <> }
    my $item = WWW::PriceMinister::Offer->new_from_content($content);
    is_deeply( $item, $expected,
        $expected ? $expected->{title} : 'empty file' );
}

