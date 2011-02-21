package MyApp::Web::Dispatcher;
use strict;
use warnings;

sub routes {
    my($self, $c, $r) = @_;
    for my $i (1 .. 50) {
        $r->connect("/myapp_web_dispatcher$i" => {
                controller => "Root",
                action     => "myapp_web_dispatcher",
            }
        );
    }
}



1;
