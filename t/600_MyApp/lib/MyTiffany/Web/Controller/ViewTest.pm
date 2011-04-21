package MyTiffany::Web::Controller::ViewTest;
use strict;
use warnings;

sub xslate {
    my ($self, $c) = @_;
    $c->render('index.tx', {name => "Xslate"});
}
sub build_template_path {
    my ($self, $c) = @_;
    $c->render;
}
1;
