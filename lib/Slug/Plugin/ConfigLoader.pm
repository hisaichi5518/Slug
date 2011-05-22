package Slug::Plugin::ConfigLoader;

use strict;
use warnings;

sub init {
    my ($self, $c, $conf) = @_;
    $c->stash->{config} = do "$conf->{file}" or die "Cannot load config file";
}

1;
