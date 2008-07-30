use strict;
use warnings;
use Test::More;
use WWW::PriceMinister;

plan tests => 4;

my $pm = WWW::PriceMinister->new();

ok( !eval { $pm->fetch(); 1 },
    'fetch() failed' );
like(
    $@,
    qr/^Can't fetch unknown PriceMinister object ''/,
    'Expected error message for fetch()'
);

ok( !eval { $pm->fetch( Zlonk => 31337 ); 1 },
    'fetch( Zlonk => ... ) failed' );
like(
    $@,
    qr/^Can't fetch unknown PriceMinister object 'Zlonk'/,
    'Expected error message for fetch( Zlonk => ... )'
);

