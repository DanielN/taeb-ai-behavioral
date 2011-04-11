package TAEB::AI::Behavioral::Behavior::ExitShop;
use Moose;
use TAEB::OO;
extends 'TAEB::AI::Behavioral::Behavior';

sub prepare {
    my $self = shift;

    return unless TAEB->current_tile->in_shop;

    my $path = TAEB::World::Path->first_match(
        sub {
            my $tile = shift;
            $tile->isa('TAEB::World::Tile::Door');
        }
    );
    $self->if_path($path => "Moving to the door");
    return if defined($path) && length($path->path) != 0;

    # look for a tile with a door nearby
    $path = TAEB::World::Path->first_match(
        sub {
            my $tile = shift;
            return 0 if $tile == TAEB->current_tile;
            return $tile->any_adjacent(sub {
                $_->isa('TAEB::World::Tile::Door');
            });
        }
    );
    $self->if_path($path => "Moving near the door");
    return if defined($path) && length($path->path) != 0;

    # look for a tile with a shopkeeper nearby
    $path = TAEB::World::Path->first_match(
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

use constant max_urgency => 'fallback';

__PACKAGE__->meta->make_immutable;

1;

