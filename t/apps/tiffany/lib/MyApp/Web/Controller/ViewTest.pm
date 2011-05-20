package MyApp::Web::Controller::ViewTest;

use strict;
use warnings;

sub xslate {
    my ($self, $c) = @_;
    $c->render('index.tx', {name => "Xslate"});
}

1;
