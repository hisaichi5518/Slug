package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';

sub startup {
    my ($self) = @_;
    $self->plugin("Web::View::Xslate" =>  {path => ["./templates"]});

    my $r = $self->routes("RSimple");
    $r->connect('/' => {controller => "ViewTest", action => "xslate"});
}

1;
