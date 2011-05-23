package MyApp::Plugin::Test;
use strict;
use warnings;

sub init {
    $_[1]->req->env->{'slug.myapp_plugin_test'} = 1;
}

1;
