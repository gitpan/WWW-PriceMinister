use strict;
use warnings;
use Test::More;
use WWW::PriceMinister;

plan tests => 1;

my $pm = WWW::PriceMinister->new();
isa_ok( $pm, 'WWW::PriceMinister' );

