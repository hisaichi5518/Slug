package Slug;

use strict;
use warnings;
use 5.008_001;
our $VERSION = '0.05';

use Slug::Trigger  ();
use Slug::Response ();
use Slug::Request  ();
use Plack::Util    ();
use Encode         ();

use Slug::Util::Accessor {
    encoding          => 'utf-8',
    html_content_type => 'text/html; charset=UTF-8',
    encode_fb         => sub { sub{} },
    trigger           => sub { Slug::Trigger->new }
};
use Plack::Util::Accessor qw(view);

{
    our $CONTEXT;
    sub context { $CONTEXT; }
    sub set_context { $CONTEXT = $_[1]; }
}
sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}
sub startup {}
sub to_app {
    my ($class, %args) = @_;
    return sub {
        my($env) = @_;
        my $self = $class->new(%args);
        Slug->set_context($self);
        $self->create_request($env);
        $self->startup;
        $self->{routes}->dispatch($self) if $self->{routes};
        $self->run_hook("after_build_response", $self, $self->response);
        return $self->response->finalize;
    };
}
sub plugin {
    my ($self, $module, $conf) = @_;
    $module = Plack::Util::load_class($module, 'Slug::Plugin');
    $module->init($self, $conf);
}
sub add_hook {
    shift->trigger->add_trigger(@_);
}
sub run_hook {
    shift->trigger->call_trigger(@_);
}
sub request {
    shift->{request};
}
sub req {
    shift->{request};
}
sub response {
    shift->{response};
}
sub res {
    shift->{response};
}
sub new_request {
    shift;
    Slug::Request->new(@_);
}
sub new_response {
    shift;
    Slug::Response->new(@_);
}
sub create_request {
    my $self = shift;
    $self->{request} = $self->new_request(@_);
}
sub create_response {
    my $self = shift;
    $self->{response} = $self->new_response(@_);
}
sub routes {
    my ($self, $name, @args) = @_;
    my $module = Plack::Util::load_class($name, "Slug::Route");
    $self->{routes} = $module->new(@args);
}
sub render {
    my ($self, $template, %args) = @_;
    unless ($template) {
        my $routing_args = $self->req->args;
        my $controller = $routing_args->{controller};
        my $action     = $routing_args->{action};
        if ($controller && $action) {
            $template = join "/", split(/::/, $controller), $action;
        }
    }
    my @after_build_tpath_codes = $self->trigger->get_trigger_code('after_build_template_path');
    for my $code (@after_build_tpath_codes) {
        $template = $code->($self, $template, %args);
    }

    my $html = $self->view->($template, %args);
    my @html_filter_codes = $self->trigger->get_trigger_code('html_filter');
    for my $code (@html_filter_codes) {
        $html = $code->($self, $html);
    }
    $html = Encode::encode($self->encoding, $html, $self->encode_fb);
    return $self->create_response(
        200,
        [
            'Content-Type' => $self->html_content_type,
            'Content-Length' => length($html),
        ],
        [$html]
    );
}
sub redirect_to {
    my ($self, $target, $args) = @_;
    my $uri = do {
        if ($target =~ /^http\:\/\//) {
            $target;
        }
        else {
            $self->req->uri_for($target, $args);
        }
    };
    return $self->create_response(
        302,
        [
            'Location' => $uri,
            'Content-Length' => 0,
        ],
        []
    );
}
sub not_found {
    my ($self, $text) = @_;
    $text ||= "404 Not Found!";
    return $self->create_response(
        404,
        ['Content-Length' => length($text)],
        [$text]
    );
}
sub stash {
    my $self = shift;
    # Initialize
    $self->{stash} ||= {};

    # Hash
    return $self->{stash} unless @_;

    # Get
    return $self->{stash}->{$_[0]} unless @_ > 1 || ref $_[0];

    # Set
    my $values = ref $_[0] ? $_[0] : {@_};
    for my $key (keys %$values) {
        $self->{stash}->{$key} = $values->{$key};
    }
    return $self->{stash};
}

1;
__END__

=encoding utf8

=head1 NAME

Slug - micro web app framework !

=head1 SYNOPSIS

  use parent "Slug";

=head1 DESCRIPTION

Slugは、Plackベースの早くて、小さいウェブアプリケーションフレームワークです。

=head1 METHOD

=head2 new

=head2 startup

=head2 to_app

=head2 plugin

=head2 add_hook

=head2 run_hook

=head2 request

=head2 req

=head2 response

=head2 res

=head2 new_request

=head2 new_response

=head2 create_request

=head2 create_response

=head2 render

=head2 not_found

=head2 stash

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Plack>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
