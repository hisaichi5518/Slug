package MyRMicro::Web;
use strict;
use warnings;

use parent 'Slug';

use FindBin;
use MyRMicro::Web::Dispatcher;

sub startup {
    my ($self) = @_;
    $self->plugin('Web::View::Xslate' =>
        {path => ["$FindBin::Bin/templates"]}
    );
    my $r = $self->routes("RMicro");
    $r->connect('/' => {controller => "Root", action => "index"});
    $r->connect("/hoge" => {controller => "Root", action => "hoge"});
    $r->connect("/404" => {controller => "Root", action => "not_found"});
    $r->connect("/change_status1" => {
        controller => "Root", action => "change_status1"});
    $r->connect("/change_status2" => {
        controller => "Root", action => "change_status2"});
    $r->connect("/change_status3" => {
        controller => "Root", action => "change_status3"});
    $r->connect("/check-env" => {
        controller => "Root", action => "check_env"});
    $r->connect("/view/xslate" => {
        controller => "ViewTest", action => "xslate"});

    MyRMicro::Web::Dispatcher->routes($self, $r);
}

1;
