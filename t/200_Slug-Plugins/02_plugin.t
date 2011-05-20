use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";

my $c;
{
    package MyApp::Web;
    use parent "Slug";

    sub startup {
        my ($self) = @_;
        $self->plugin("+MyApp::Plugin::Test");
        $c = $self;
        $self->ok("ok");
    }
}
my $app = MyApp::Web->to_app->({});
ok $c->req->env->{'slug.myapp_plugin_test'};

done_testing;
