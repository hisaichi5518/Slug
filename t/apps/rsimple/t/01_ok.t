use strict;
use warnings;
use Plack::Test;
use Plack::Util;
use Test::More;

my $app = Plack::Util::load_psgi 'app.psgi';
test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/');
        my $res = $cb->($req);
        is $res->code, 200;
        is $res->content, "index";
        diag $res->content if $res->code != 200;
    };

test_psgi(
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/submapper/'. $_);
        my $res = $cb->($req);
        is $res->code, 200;
        is $res->content, "res$_";
        diag $res->content if $res->code != 200;
    }) for (1 .. 2);

test_psgi(
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/myapp_web_dispatcher'. $_);
        my $res = $cb->($req);
        is $res->code, 200;
        is $res->content, "myapp_web_dispatcher";
        diag $res->content if $res->code != 200;
    }) for (1 .. 10);

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/404');
        my $res = $cb->($req);
        is $res->code, 404;
        is $res->content, "404 Not Found!";
        diag $res->content if $res->code != 404;
    };

done_testing;

