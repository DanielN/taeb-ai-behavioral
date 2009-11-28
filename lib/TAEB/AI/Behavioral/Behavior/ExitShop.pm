package TAEB::AI::Behavioral::Behavior::ExitShop;
use TAEB::OO;
extends 'TAEB::AI::Behavioral::Behavior';

sub prepare {
    my $self = shift;

    return unless TAEB->current_tile->in_shop;

    # look for a tile with a shopkeeper nearby
    my $path = TAEB::World::Path->first_match(
        sub {
            my $tile = shift;
            return 0 if $tile == TAEB->current_tile;
            return $tile->any_adjacent(sub {
                $_->has_monster && $_->monster->is_shk
            });
        }
    );

    $self->if_path($path =>
        sub { "Moving towards the shopkeeper" },
        'fallback');
}

__PACKAGE__->meta->make_immutable;

1;

