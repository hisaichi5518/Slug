package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';
use MyApp::Web::Dispatcher;
use Tiffany::Text::Xslate;
use FindBin;

sub startup {
    my ($self) = @_;
    my $v = Tiffany::Text::Xslate->new({
        path => ["$FindBin::Bin/templates"],
    });
    $self->view($v);
    MyApp::Web::Dispatcher->dispatch($self);
}

1;
