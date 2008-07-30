use strict;
use warnings;
use Test::More;
use WWW::PriceMinister::Object;

my @tests = (
    [ {} ],
    [ { zlonk => 'bam', kapow => 'awk' }, zlonk => 'bam', kapow => 'awk' ],
);

plan tests => 2 * @tests;

for my $t (@tests) {
    my ( $expected, @args ) = @$t;
    my $offer = WWW::PriceMinister::Object->new(@args);
    isa_ok( $offer, 'WWW::PriceMinister::Object' );
    is_deeply( $offer, $expected, "Expected object for [ @args ]" );
}

