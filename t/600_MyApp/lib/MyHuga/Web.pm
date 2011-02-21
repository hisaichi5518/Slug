package MyHuga::Web;
use strict;
use warnings;

use parent 'Slug';

use FindBin;

sub startup {
    my ($self) = @_;
    $self->plugin("Web::View::Tiffany" => {
        "Text::Xslate" => {path => ["$FindBin::Bin/templates"]},
    });

    my $r = $self->routes("RSimple");
    $r->connect('/' => {controller => "ViewTest", action => "xslate"});
}

1;
