package MyApp::Web::Controller::Root;
use strict;
use warnings;

sub index {
    my ($self, $c) = @_;
    $c->render("index.tx", {name => "hisaichi5518"});
}

1;
