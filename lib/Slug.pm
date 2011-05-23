package Slug;

use strict;
use warnings;
use 5.008_001;

use Slug::Plugins  ();
use Slug::Response ();
use Slug::Request  ();
use Plack::Util    ();
use Encode         ();
use Slug::Util::Accessor {
    html_content_type => 'text/html; charset=UTF-8',
    view              => "",
};

our $VERSION = '0.12';

{
    my $CONTEXT;
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
        $self->plugins->before_dispatch($self);
        $self->routes->dispatch($self) if $self->routes;
        $self->plugins->after_dispatch($self);
        return $self->response->finalize;
    };
}
sub encoding {
    my ($self, $encoding) = @_;
    return $self->{encoding} if !$encoding && exists $self->{encoding};
    $self->{encoding} = Encode::find_encoding($encoding || 'utf8') or die "encoding '$encoding' not found";
}
sub plugins {
    shift->{plugins} ||= Slug::Plugins->new;
}
sub plugin {
    my ($self, $name, $conf) = @_;
    $self->plugins->init_plugin($name, $self, $conf);
}
sub hook {
    shift->plugins->add_hook(@_);
}
sub trigger {
    _deprecated('trigger' => 'plugins');
    shift->{trigger} ||= Plack::Util::load_class('Slug::Trigger')->new;
}
sub add_hook {
    _deprecated("add_hook" => "hook");
    shift->plugins->add_hook(@_);
}
sub run_hook {
    _deprecated("run_hook" => "plugins->run_hook");
    shift->plugins->run_hook(@_);
}
sub request  { shift->{request}  }
sub req      { shift->{request}  }
sub response { shift->{response} }
sub res      { shift->{response} }
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
    my ($self, $name, %args) = @_;
    return $self->{routes} unless $name;
    $self->{routes} = Plack::Util::load_class($name, "Slug::Routes")->new(%args);
}
sub encode {
    my ($self, $str) = @_;
    $self->encoding->encode($str);
}
sub render {
    my ($self, $template, $args) = @_;
    $template = $self->plugins->template_path($self, $template, $args) || $template;
    my $html  = $self->view->($template, $args);
       $html  = $self->plugins->html_filter($self, $html) || $html;
    $self->ok($html);
}
sub ok {
    my ($self, $html) = @_;
    return $self->create_response(
        200,
        [
            'Content-Type' => $self->html_content_type,
            'Content-Length' => length($html),
        ],
        [Encode::is_utf8($html) ? $self->encode($html) : $html]
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
        [Encode::is_utf8($text) ? $self->encode($text) : $text]
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
sub _deprecated {
    require Carp;
    Carp::carp($_[0] . " is deprecated. use ". $_[1] . ".");
}

1;
__END__

=encoding utf8

=head1 NAME

Slug - micro web app framework !

=head1 SYNOPSIS

  # Web.pm
  package MyApp::Web;
  use parent "Slug";
  
  sub startup {
    my ($self) = @_;
    
    $self->plugin("Web::View::Xslate" => {path => ["./templates"]);
    
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => "Root", action => "index"});
  }
  
  # Root.pm
  package MyApp::Web::Controller::Root;
  use strict;
  use warnings;
  
  sub index {
    my ($self, $c) = @_;
    $c->render('index.tx');
  }
  
  # index.tx
  Hello World!

=head1 DESCRIPTION

Slugは、Plackベースの早くて、小さいウェブアプリケーションフレームワークです。

=head1 METHOD

Slug.pm は、継承して使います。
ここでは、MyApp::Web に継承したとして説明しています。

=head2 new

  my $c = MyApp::Web->new;

=head2 startup

  $app->startup;

アプリケーションが開始した時に呼び出されるフックです。

他のフックとは違い、 add_hook は使わずに以下のようにします。

sub startup {
    my ($self) = @_;
    ...
  }

何か値を返さなければならないという事はありません。

=head2 to_app

  MyApp::Web->to_app;

.psgi ファイルの中で使います。
Slugがどういう流れで動いてるか確認したい場合はここを見たらよいでしょう。

=head2 encoding

  $c->encoding;
  $c->encoding('shift_jis');

引数があった場合、$c->{encoding} がない場合は、Encode::Encoding のオブジェクトを $c->{encoding} に代入します。
引数がなく、$c->{encoding} がある場合は、$c->{encoding} を返します。

=head2 plugins

  $c->plugins;

Slug::Plugins のオブジェクトを返します。

=head2 plugin

  $c->plugin("ConfigLoader" => {});
  $c->plugin("+MyApp::Hooks");

$c->plugins->init_plugin; のショートカットです。

プラグインを呼び出します。

=head2 hook

  $c->hook("after_dispatch" => sub {});

$c->plugins->add_hook; のショートカットです。

フックを追加します。

=head2 request

  $c->request;
  $c->req;

Slug::Request のオブジェクトがあればオブジェクトを返します。

req も同じように動きます。

=head2 response

  $c->response;
  $c->res;

Slug::Response のオブジェクトがあればオブジェクトを返します。

res も同じように動きます。

=head2 new_request

  $c->new_request;

Slug::Request->new; を行います。

*注意* これだけでは、$c->{request} にオブジェクトは代入されません。

$c->{request} に代入したい場合は、create_request を使ってください。

=head2 new_response

  $c->new_response;

Slug::Response->new; を行います。

*注意* これだけでは、$c->{response} にオブジェクトは代入されません。

$c->{response} に代入したい場合は、create_response を使ってください。

=head2 create_request

  $c->create_request;

new_request して、$c->{request} に代入します。

=head2 create_response

  $c->create_response;

new_response して、$c->{response} に代入します。

=head2 routes

  $c->routes;                   #=> $c->{routes};
  $c->routes('RSimple');        #=> Slug::Routes::RSimple->new;
  $c->routes('+MyApp::Routes'); #=> MyApp::Routes->new;

=head2 encode

  $c->encode($str);

encoding を使ってencodeします。

=head2 render

  $c->render("index.tx", { hoge => 1 });

テンプレートエンジンを呼び出してhtmlを構成し、200を返すように create_response を行います。

renderを使用するには、viewが設定されている必要があります。

=head2 ok

  $c->ok($html);

200で create_response します。

=head2 redirect_to

  $c->redirect_to('http://localhost/');
  $c->redirect_to('/user/hisaichi5518', [hoge => 1]);

リダイレクトするように create_response します。

=head2 not_found

  $c->not_found($text);

404 で create_response します。

=head2 stash

  $c->stash('config');
  $c->stash(config => {hgoe => 1});
  delete $c->stash->{config};

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Plack>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
