package Slug::Plugin::Test;
use strict;
use warnings;
sub init {
    my ($class, $c, $conf) = @_;
    $c->req->env->{'slug.test_plugin'} = "on";
}
1;
