# Amon2/t/100_core/001_request_param_decoded.t
use strict;
use warnings;
use utf8;
use Slug;
use Slug::Request;
use URI::Escape;
use Encode;
use Test::More;
{
    package MyApp;
    use parent "Slug";
    sub startup {
        shift->create_response(200, [], ["ok!"]);
    }
}

Slug->set_context(MyApp->new);
my $req = Slug::Request->new({
    QUERY_STRING   => 'foo=%E3%81%BB%E3%81%92&bar=%E3%81%B5%E3%81%8C1&bar=%E3%81%B5%E3%81%8C2',
    REQUEST_METHOD => 'GET',
});
ok Encode::is_utf8($req->param('foo'));
ok Encode::is_utf8($req->query_parameters->{'foo'});
is $req->param('foo'), 'ほげ';
is_deeply [$req->param('bar')], ["ふが1", "ふが2"];

ok !Encode::is_utf8($req->param_raw('foo'));
ok !Encode::is_utf8($req->parameters_raw->{'foo'});


done_testing;
