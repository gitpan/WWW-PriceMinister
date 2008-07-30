#!perl -T
use strict;
use warnings;
use Test::More;

my @modules = qw(
    WWW::PriceMinister
    WWW::PriceMinister::Object
    WWW::PriceMinister::Item
    WWW::PriceMinister::Offer
    WWW::PriceMinister::Seller
);

plan tests => scalar @modules;

use_ok( $_ ) for @modules; 

