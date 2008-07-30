package t::Util;

use strict;
use warnings;
use LWP::UserAgent;
use Exporter;

our @ISA    = qw( Exporter );
our @EXPORT = qw( &web_ok &flesh );

# some basic content for WWW::PriceMinister::Item objects
my %flesh = (
    wall => {
        id    => '883778',
        title => 'Programming Perl - 3rd Edition',
    },
    larsson => {
        id => '46661315',
        title =>
            q{Millénium Tome 1 - Les Hommes Qui N'aimaient Pas Les Femmes},
    },
    perec => {
        id    => '255928',
        title => q{W Ou Le Souvenir D'enfance},
    },
);

1;

# check that the web connection is working
sub web_ok {
    my $ua = LWP::UserAgent->new( env_proxy => 1, timeout => 30 );
    my $res = $ua->request(
        HTTP::Request->new(
            GET => shift || 'http://www.google.com/intl/en/'
        )
    );
    return $res->is_success;
}

sub flesh { return %{ $flesh{ shift() } }; }

