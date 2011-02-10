package MyApp::Web::Controller::Root;
use strict;
use warnings;

sub index {
    my ($self, $app) = @_;
    $app->render("index.tx");
}

1;
