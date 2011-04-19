use strict;
use warnings;
use Test::More;
use Slug;
use Slug::Trigger;
use Slug::Response;

my $s = Slug->new;
is $s->encoding, "utf-8";
is $s->html_content_type, "text/html; charset=UTF-8";
is $s->encode_fb->(), undef;

$s->encoding('shift-jis');
$s->html_content_type("text/html; charset=Shift-JIS");
$s->encode_fb(sub{});
is $s->encoding, 'shift-jis';
is $s->html_content_type, 'text/html; charset=Shift-JIS';
is ref $s->encode_fb, "CODE";

isa_ok $s->new_request({ PATH_INFO => "/" }), "Slug::Request";
isa_ok $s->new_response(200, [], ["ok!"]), "Slug::Response";

is_deeply $s->create_request({ PATH_INFO => "/", SCRIPT_NAME => "/", HTTP_HOST => "localhost" }), $s->request;
is_deeply $s->create_response(200, [], ["ok!"]), $s->response;
is_deeply $s->trigger, Slug::Trigger->new;

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
done_testing;
