package WWW::PriceMinister::Object;

use strict;
use warnings;
use HTML::TreeBuilder;
use WWW::PriceMinister::Offer;

1;

sub new {
    my ( $class, %args ) = @_;
    return bless {%args}, $class;
}

sub new_from_content {
    my ( $class, $content ) = @_;
    return if !$content;

    my $self = bless {}, $class;

    my $tree = HTML::TreeBuilder->new_from_content($content);
    $self->_update_from_tree($tree);
    $tree->delete();

    return $self;
}

sub trim_text {
    my ( $self, $text ) = @_;
    $text =~ s/[\n\r\f\t ]+$//s;
    $text =~ s/^[\n\r\f\t ]+//s;
    $text =~ s/[\n\r\f\t ]+/ /g;
    return $text;
}

sub format_price {
    my ( $self, $price ) = @_;
    $price =~ y/,/./;
    $price =~ s/[^\d.]//g;
    return $price;
}

__END__

=head1 NAME

WWW::PriceMinister::Object - An object scraped from the PriceMinister website

=head1 SYNOPSIS

    package WWW::PriceMinister::Thingy;

    use WWW::PriceMinister::Object;
    our @ISA = qw( WWW::PriceMinister::Object );

    # WWW::PriceMinister::Thingy now inherits
    # - new()
    # - new_from_content()

=head1 DESCRIPTION

C<WWW::PriceMinister::Object> is an abstract base class for
object scraped from the PriceMinister web site.

=head1 METHODS

C<WWW::PriceMinister::Object> provides the following methods:

=over 4

=item new( %params )

Return an object which attributes are setup according to the content
of C<%params>.

=item new_from_content( $content )

Return an object created from the given HTML source (supposedly obtained
from the Price Minister web site).

Return C<undef> if no sufficient information could be obtained.

This method calls a C<_update_from_tree()> method that takes a
C<HTML::Element> tree object as its only parameter. It must be defined
in the subclass.

=item trim_text( $text )

Return the given C<$text> with leading and trailing whitespace deleted,
and any internal whitespace collapsed.

=item format_price( $price )

Format PriceMinister price values to make them usable as Perl numbers.

=back

=head1 AUTHOR

Philippe Bruhat (BooK), C<< <book@cpan.org> >>.

=head1 COPYRIGHT 

Copyright 2008 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

