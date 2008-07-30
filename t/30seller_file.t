use strict;
use warnings;
use Test::More;
use WWW::PriceMinister::Seller;

use t::Util;

my @tests = (

    # file, result
    [],
    [   't/html/seller-suchelle.html' => WWW::PriceMinister::Seller->new(
            id              => 'suchelle',
            ventes          => 1,
            score           => '5',
            response_time   => '24h 18min',
            acceptance_rate => '100 %',
            member_since    => '08/08/2005',
            last_visit      => '25/07/2008',
        )
    ],
    [   't/html/seller-BOULOU06.html' => WWW::PriceMinister::Seller->new(
            id              => 'BOULOU06',
            ventes          => 299,
            score           => '4.8',
            response_time   => '5h 00min',
            acceptance_rate => '93 %',
            member_since    => '11/03/2007',
            last_visit      => '30/07/2008',
        )
    ]
);

plan tests => scalar @tests;

for my $t (@tests) {
    my ( $file, $expected ) = @$t;
    my $content;
    if ($file) { local $/; local @ARGV = $file; $content = <> }
    my $item = WWW::PriceMinister::Seller->new_from_content($content);
    is_deeply( $item, $expected, $expected ? $expected->{id} : 'empty file' );
}

