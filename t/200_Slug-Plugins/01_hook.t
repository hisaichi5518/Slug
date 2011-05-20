use strict;
use warnings;

use Test::More;

{
    package MyApp::Web;
    use parent "Slug";

    sub startup {
        my ($self) = @_;
        $self->plugins->add_hook(before_dispatch => sub { shift->req->env->{'slug.hook'} = "before" });
        $self->plugins->add_hook(after_dispatch  => sub { shift->req->env->{'slug.hook'} = "after" });
        $self->plugins->add_hook(template_path   => sub { "index.tx" });
        $self->plugins->add_hook(html_filter     => sub { "index" });
        $self->view(sub { die unless $_[0]; "unko" });
        $self->render;
    }
}

my $app = MyApp::Web->to_app->({PATH_INFO => "/"});
is $app->[2]->[0], "index";

done_testing;
