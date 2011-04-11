use strict;
use warnings;
use Test::Requires qw/Tiffany/;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";


use Test::WWW::Mechanize::PSGI;
use MyTiffany::Web;

my $mech = Test::WWW::Mechanize::PSGI->new(
    app => MyTiffany::Web->to_app,
);
$mech->get_ok('/');
is $mech->ct, 'text/html';
$mech->title_is('hi!');
$mech->content_contains('Hello Xslate World!');

$mech->get_ok('/build-template-path');
is $mech->ct, 'text/html';
$mech->title_is('hi!');
$mech->content_contains('Hello Xslate World!');

done_testing;
