use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::WWW::Mechanize::PSGI;
use MyApp::Web;

my $mech = Test::WWW::Mechanize::PSGI->new(
    app => MyApp::Web->to_app,
);
$mech->get_ok('/');
is $mech->ct, 'text/html';
$mech->content_contains('ok!');

$mech->get_ok('/hoge');
is $mech->ct, 'text/html';
$mech->content_contains('hoge!');

$mech->get('/404');
ok !$mech->success;
$mech->get_ok('/change_status1');
$mech->get_ok('/change_status2');
$mech->get_ok('/change_status3');
$mech->get_ok('/check-env');

$mech->get_ok('/view/xslate');
is $mech->ct, 'text/html';
$mech->title_is('hi!');
$mech->content_contains('Hello Xslate World!');


done_testing;
