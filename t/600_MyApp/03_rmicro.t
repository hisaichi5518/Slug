use strict;
use warnings;
use Test::Requires qw/Router::Micro/;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::WWW::Mechanize::PSGI;
use MyRMicro::Web;

my $mech = Test::WWW::Mechanize::PSGI->new(
    app => MyRMicro::Web->to_app,
);
$mech->get_ok('/');
is $mech->ct, 'text/html';
$mech->content_contains('ok!');

$mech->get_ok('/hoge');
is $mech->ct, 'text/html';
$mech->content_contains('hoge!');

$mech->get('/404');
ok !$mech->success;

for my $i (1 .. 50) {
    $mech->get_ok("/myapp_web_dispatcher$i");
    $mech->content_contains('ok');
}
done_testing;
