use strict;
use warnings;
use Test::More;
use WWW::PriceMinister::Item;

my @text = (
    [ 'abc'          => 'abc' ],
    [ ' abc '        => 'abc' ],
    [ " \t\n ab \nc" => 'ab c' ],
);

my @price = ( [ '16,00 €' => '16.00' ], [ 'zlonk' => '' ], );

plan tests => @text + @price;

# test _trimmed_text
for my $t (@text) {
    my ( $src, $dst ) = @$t;
    is( WWW::PriceMinister::Item->trim_text($src), $dst, $dst );
}

# test format_price
for my $t (@price) {
    my ( $src, $dst ) = @$t;
    is( WWW::PriceMinister::Item->format_price($src), $dst, $dst );
}

