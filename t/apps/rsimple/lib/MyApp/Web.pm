package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';
use MyApp::Web::Dispatcher;

sub startup {
    my ($self) = @_;
    my $r = $self->routes("RSimple");
    $r->connect('/' => {controller => "Root", action => "index"});
    my $s = $r->submapper("/submapper" => {controller => "Root"});
    $s->connect('/1', {action => "res1"});
    $s->connect('/2', {action => "res2"});
    $r->connect("/namespace" => {namespace => "MyApp::C", controller => "Root", action => "index"});

    MyApp::Web::Dispatcher->connections($self, $r);
}

1;
