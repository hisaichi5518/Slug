package Slug::Routes::RMicro;
use strict;
use warnings;

use parent "Router::Micro";
use Slug::Routes;

sub dispatch {
    my ($self, $c) = @_;
    Slug::Routes->dispatch($c);
}

1;
__END__

=encoding utf8

=head1 NAME

Slug::Route::RMicro - Router::Micro

=head1 SYNOPSIS

  use Slug::Routes::RMicro;
  my $r = Slug::Routes::RMicro->new;
  # my $r = Slug::Routes::RMicro->new(namespace => "MyApp::C");
  $r->connect('/' => {controller => "Root", action => "index"});

=head1 DESCRIPTION

高速なRouter Class である Router::Micro を Slug で使う為のクラス

=head1 ARGS

=head2 namespace

MyApp::Web::Controller 以下にコントローラを置きたくない場合に使う。

これはnew でも指定する事が出来るが、argsで指定したほうが優先される。

=head2 controller

コントローラを指定する。

一番前に「 + 」を付けるとnamespaceが無視される。

controllerが指定されていないと404を返す。

=head2 action

アクションを指定する。

actionが指定されていないと404を返す。

=head1 METHOD

Router::Micro を継承しています。

=head2 dispatch

  $c->dispatch($c);

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Router::Micro>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
