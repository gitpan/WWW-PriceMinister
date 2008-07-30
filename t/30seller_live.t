use strict;
use warnings;
use Test::More;
use WWW::PriceMinister;

use t::Util;

my @tests = (
    {   id              => 'suchelle',
        ventes          => 1,
        score           => '5',
        acceptance_rate => '100 %',
        member_since    => '08/08/2005',
    },
    {   id              => 'bruhatp',
        ventes          => 19,
        score           => '4.5',
        acceptance_rate => '100 %',
        member_since    => '29/05/2006',
    }
);

plan tests => 6 * @tests;

my $pm = WWW::PriceMinister->new();

for my $s (@tests) {
    my $seller = $pm->fetch_seller( $s->{id} );
    isa_ok( $seller, 'WWW::PriceMinister::Seller' );
    is( $seller->{id}, $s->{id}, "id = $s->{id}" );
    cmp_ok( $seller->{ventes}, '>=', $s->{ventes},
        "at least $s->{ventes} sales" );
    cmp_ok( $seller->{score}, '>=', $s->{score}, "score >= $s->{score}" );
    is( $seller->{acceptance_rate},
        $s->{acceptance_rate}, "acceptance_rate $s->{acceptance_rate}" );
    is( $seller->{member_since},
        $s->{member_since}, "member_since $s->{member_since}" );
}

