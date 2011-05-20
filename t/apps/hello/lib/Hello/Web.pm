package Hello::Web;
use strict;
use warnings;

use parent 'Slug';

sub startup {
    my ($self) = @_;
    $self->ok("hello!");
}

1;
