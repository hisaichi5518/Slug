package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';
use Tiffany::Text::Xslate;

sub startup {
    my ($self) = @_;
    $self->view(Tiffany::Text::Xslate->new({
        path => ["./templates"],
    }));

    my $r = $self->routes("RSimple");
    $r->connect("/" => {controller => "Root", action => "index"});
    $r->connect("/huga" => {controller => "Root", action => "index"});
}

1;
