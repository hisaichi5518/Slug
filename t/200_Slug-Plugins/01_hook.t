use strict;
use warnings;

use Test::More;

{
    package Slug::Test::View;
    sub new {
        my $class = shift;
        my %args = @_ == 1 ? %{$_[0]} : @_;
        bless {%args}, $class;
    }
    sub render {
        my ($self, $path, $args) = @_;
        die "template_path" unless $path;
        "html";
    }
}
{
    package MyApp::Web;
    use parent "Slug";

    my $view = Slug::Test::View->new;
    sub startup {
        my ($self) = @_;
        $self->plugins->add_hook(template_path =>
            sub { "template_path" }
        );
        $self->plugins->add_hook(template_path =>
            sub {
                my ($c, $path, $args) = @_;
                $path eq "template_path" ? "ok.tx" : "ng.tx";
            }
        );
        $self->plugins->add_hook(html_filter =>
            sub {
                my ($c, $html) = @_;
                $html eq "html" ? "ok" : "ng";
            }
        );
        $self->plugins->add_hook(html_filter =>
            sub {
                my ($c, $html) = @_;
                die "html_filter" unless $html eq "ok";
                "ok!";
            }
        );
        $self->plugins->add_hook(before_dispatch =>
            sub {
                my ($c) = @_;
                $c->req->env->{'slug.hook'} = "before";
            }
        );
        $self->plugins->add_hook(after_dispatch  =>
            sub {
                my ($c) = @_;
                $c->res->header("X-Slug" => "OK") if $c->req->env->{'slug.hook'} eq "before";
            }
        );
        $self->view($view);
        $self->render;
    }
}

my $app = MyApp::Web->to_app->({PATH_INFO => "/"});
is_deeply +{@{$app->[1]}}, +{@{["Content-Type" => "text/html; charset=UTF-8", "Content-Length" => 3, "X-Slug" => "OK"]}};
is_deeply $app->[2], ["ok!"];

done_testing;
