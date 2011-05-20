use strict;
use warnings;
use utf8;

use Test::More;
use Slug;
use Slug::Plugins;
use Slug::Response;
use Encode ();

my $s = Slug->new;
{
    is $s->encoding->mime_name, "UTF-8";
    $s->encoding('shift_jis');
    is $s->encoding->mime_name, 'Shift_JIS';
    $s->encoding('sjis');
    is $s->encoding->mime_name, 'Shift_JIS';

    isa_ok $s->plugins, "Slug::Plugins";

    isa_ok $s->new_request({ PATH_INFO => "/" }), "Slug::Request";
    isa_ok $s->new_response(200, [], ["ok!"]), "Slug::Response";

    ok !$s->request;
    ok !$s->response;
    is_deeply $s->create_request({ PATH_INFO => "/", SCRIPT_NAME => "/", HTTP_HOST => "localhost" }), $s->request;
    is_deeply $s->create_response(200, [], ["ok!"]), $s->response;

    isa_ok $s->routes('RSimple'), "Slug::Routes::RSimple";

    $s->encoding('utf-8');
    my $str = $s->encode("日本語");
    ok !(Encode::is_utf8($str));
    is $str, Encode::encode_utf8("日本語");


    is_deeply $s->ok("hoge"), Slug::Response->new(200,['Content-Type' => $s->html_content_type, 'Content-Length' => 4],["hoge"]);

    is_deeply $s->redirect_to("/"), Slug::Response->new(302,["Location" => "http://localhost/", "Content-Length" => 0],[]);
    is_deeply $s->redirect_to("/hoge"), Slug::Response->new(302,["Location" => "http://localhost/hoge", "Content-Length" => 0],[]);
    is_deeply $s->redirect_to("hoge/hoge"), Slug::Response->new(302,["Location" => "http://localhost/hoge/hoge", "Content-Length" => 0],[]);

    is_deeply $s->not_found, Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
    is_deeply $s->not_found(0), Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
    is_deeply $s->not_found(""), Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
    is_deeply $s->not_found("hoge"), Slug::Response->new(404,['Content-Length' => 4],["hoge"]);

    for my $i (0 .. 50) {
        $s->stash($i => $i);
        is $s->stash($i), $i;
        is $s->stash->{$i}, $i;
    }
}

done_testing;
