package MyApp::Web::Dispatcher;
use strict;
use warnings;

use Slug::Route::RSimple qw( connect submapper dispatch );
connect("/" => {controller => "Root", action => "index"});
connect("/hoge" => {controller => "Root", action => "hoge"});
connect("/404" => {controller => "Root", action => "not_found"});
connect("/change_status1" => {
        controller => "Root", action => "change_status1"});
connect("/change_status2" => {
        controller => "Root", action => "change_status2"});
connect("/change_status3" => {
        controller => "Root", action => "change_status3"});
connect("/check-env" => {
        controller => "Root", action => "check_env"});
connect("/view/xslate" => {
        controller => "ViewTest", action => "xslate"});





1;
