package MyApp::Web;
use strict;
use warnings;

use parent 'Slug';
use MyApp::Web::Dispatcher;
use Tiffany::Text::Xslate;
use Path::Class qw(dir);

sub startup {
    my ($self) = @_;
    # $self->plugin("Web::MobileAgent" => {});
    # $self->plugin("Web::MobileEmoji" => {});
    # $self->plugin("Web::IsMobileIP"  => {});

    my $v = Tiffany::Text::Xslate->new({
        path => [dir("templates")],
        function => {
            app => sub { $self }
        }
    });
    $self->view($v);
    # $self->dispatcher('MyApp::Web::Dispatcher');
    MyApp::Web::Dispatcher->dispatch($self);
}

1;
