package MyApp::C::Root;

use strict;
use warnings;

sub index {
    my ($self, $c) = @_;
    $c->ok("ok!");
}

1;
