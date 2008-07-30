use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::PriceMinister',
    license             => 'perl',
    dist_author         => 'Philippe Bruhat (BooK) <book@cpan.org>',
    dist_version_from   => 'lib/WWW/PriceMinister.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'HTML::TreeBuilder' => 3,
        'WWW::Mechanize'    => '1.20',
    },
    add_to_cleanup      => [ 'WWW-PriceMinister-*' ],
);

$builder->create_build_script();
