package MyHuga::Web::Controller::ViewTest;
use strict;
use warnings;

sub xslate {
    my ($self, $c) = @_;
    $c->render('index.tx');
}
sub build_template_path {
    my ($self, $c) = @_;
    $c->render;
}
1;
