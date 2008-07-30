package WWW::PriceMinister::Seller;
use strict;
use warnings;

use HTML::TreeBuilder;
use WWW::PriceMinister::Object;

our @ISA = qw( WWW::PriceMinister::Object );

1;

sub _update_from_tree {
    my ( $self, $tree ) = @_;
    my $s = $tree->look_down( _tag => 'div', id => 'seller_profile_block' );

    # id
    ( $self->{id} )
        = $s->look_down( _tag => 'a' )->attr('href')
        =~ /47,'boutique',47,'(\w+)'/g;

    # score and number of sales
    @{$self}{qw( score ventes )}
        = map { $_->as_trimmed_text } $s->look_down( _tag => 'em' );
    $self->{score} =~ s{/5$}{};
    $self->{score} =~ y/,/./;

    # stats
    @{$self}{qw( response_time acceptance_rate member_since last_visit )}
        = map { $_->as_trimmed_text }
        $s->look_down( _tag => 'span', class => 'pvr' );
}

__END__

=head1 NAME

WWW::PriceMinister::Seller - A seller on Price Minister

=head1 SYNOPSIS

    use WWW::PriceMinister;

    # my profile
    my $seller = WWW::PriceMinister->new()->fetch_seller( 'bruhatp' );

=head1 DESCRIPTION

C<WWW::PriceMinister::Seller> represents a seller on the
PriceMinister online store.

=head1 METHODS

C<WWW::PriceMinister::Seller> inherits the following methods from
C<WWW::PriceMinister::Object>:

=over 4

=item new( %params )

=item new_from_content( $content )

=back


=head1 AUTHOR

Philippe Bruhat (BooK), C<< <book@cpan.org> >>.

=head1 COPYRIGHT 

Copyright 2008 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

