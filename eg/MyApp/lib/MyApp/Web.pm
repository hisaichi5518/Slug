package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';
use FindBin;

sub startup {
    my ($self) = @_;
    $self->plugin("Web::View::Xslate" => {
        path => ["$FindBin::Bin/templates"],
    });

    my $r = $self->routes("RSimple");
    $r->connect("/" => {controller => "Root", action => "index"});
}

1;
