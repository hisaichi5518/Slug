package MyRMicro::Web;
use strict;
use warnings;

use parent 'Slug';

use FindBin;
use MyRMicro::Web::Dispatcher;

sub startup {
    my ($self) = @_;
    $self->plugin('Web::View::Xslate' =>
        {path => ["$FindBin::Bin/templates"]}
    );
    my $r = $self->routes("RMicro");
    $r->connect('/' => {controller => "Root", action => "index"});
    $r->connect("/hoge" => {controller => "Root", action => "hoge"});
    $r->connect("/404" => {controller => "Root", action => "not_found"});

    MyRMicro::Web::Dispatcher->routes($self, $r);
}

1;
