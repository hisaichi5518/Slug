use strict;
use warnings;
use utf8;

use Test::More;
use Encode qw(encode_utf8);
{
    package MyApp::Web;
    use parent "Slug";
    sub startup {
        my ($self) = @_;
        $self->stash(test => 1);
        $self->ok("日本語");
    }
}

my $app = MyApp::Web->new;
isa_ok $app, "MyApp::Web";
ok !(MyApp::Web->context);
is(MyApp::Web->set_context("myapp"), "myapp");
is(MyApp::Web->context, "myapp");
is $app->context, "myapp";
is $app->set_context("MyApp"), "MyApp";
is $app->context, "MyApp";

is(Slug->context, "MyApp");
is(Slug->set_context("slug"), "slug");
is(MyApp::Web->context, "slug");
is $app->context, "slug";
is $app->set_context("Slug"), "Slug";
is $app->context, "Slug";

ok !($app->req);
ok !($app->res);
isa_ok $app->plugins, "Slug::Plugins";

for my $i (0 .. 50) {
    $app->stash($i => $i);
    is $app->stash($i), $i;
    is $app->stash->{$i}, $i;
    delete $app->stash->{$i};
    ok !($app->stash($i));
}
my $res = MyApp::Web->to_app(test => 1)->({ HTTP_HOST => "localhost" });
my $c   = Slug->context;
isa_ok $c, "MyApp::Web";
ok $c->{test};
isa_ok $c->request, "Slug::Request";
isa_ok $c->response, "Slug::Response";
isa_ok $c->encoding, "Encode::Encoding";
is $c->encoding->mime_name, "UTF-8";

is $res->[0], 200;
is_deeply +{@{$res->[1]}}, +{@{["Content-Type" => "text/html; charset=UTF-8", "Content-Length" => 3]}};
is_deeply $res->[2], [encode_utf8("日本語")];

$res = $c->ok(encode_utf8("日本語"))->finalize;
is $res->[0], 200;
is_deeply +{@{$res->[1]}}, +{@{["Content-Type" => "text/html; charset=UTF-8", "Content-Length" => 9]}};
is_deeply $res->[2], [encode_utf8("日本語")];

$res = $c->redirect_to("http://localhost/")->finalize;
is $res->[0], 302;
is_deeply +{@{$res->[1]}}, +{@{["Content-Length" => 0, Location => "http://localhost/"]}};
is_deeply $res->[2], [];

$res = $c->redirect_to("/")->finalize;
is $res->[0], 302;
is_deeply +{@{$res->[1]}}, +{@{["Content-Length" => 0, Location => "http://localhost/"]}};
is_deeply $res->[2], [];

$res = $c->redirect_to("/", [hoge => 1])->finalize;
is $res->[0], 302;
is_deeply +{@{$res->[1]}}, +{@{["Content-Length" => 0, Location => "http://localhost/?hoge=1"]}};
is_deeply $res->[2], [];

$res = $c->not_found("日本語")->finalize;
is $res->[0], 404;
is_deeply +{@{$res->[1]}}, +{@{["Content-Length" => 3]}};
is_deeply $res->[2], [encode_utf8("日本語")];

$res = $c->not_found(encode_utf8("日本語"))->finalize;
is $res->[0], 404;
is_deeply +{@{$res->[1]}}, +{@{["Content-Length" => 9]}};
is_deeply $res->[2], [encode_utf8("日本語")];

$res = $c->not_found->finalize;
is_deeply $res->[2], ["404 Not Found!"];

$res = $c->not_found(0)->finalize;
is_deeply $res->[2], ["404 Not Found!"];

$res = $c->not_found("")->finalize;
is_deeply $res->[2], ["404 Not Found!"];




done_testing;
