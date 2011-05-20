package MyApp::Web::Dispatcher;
use strict;
use warnings;

sub connections {
    my($self, $c, $r) = @_;
    $r->connect("/myapp_web_dispatcher$_" => {
        controller => "Root",
        action     => "myapp_web_dispatcher",
    }) for (1..10);
}

1;
