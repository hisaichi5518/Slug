package MyApp::Web::Controller::Root;

use strict;
use warnings;

sub index {
    my ($self, $c) = @_;
    $c->ok($c->req->args->{index});
}
sub res1 {
    my ($self, $c) = @_;
    $c->ok("res1");
}
sub res2 {
    my ($self, $c) = @_;
    $c->ok("res2");
}
sub myapp_web_dispatcher {
    my ($self, $c) = @_;
    $c->ok("myapp_web_dispatcher");
}

1;
