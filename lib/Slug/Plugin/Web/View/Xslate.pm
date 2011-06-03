package Slug::Plugin::Web::View::Xslate;
use strict;
use warnings;

use Text::Xslate;

sub init {
    my ($self, $c, $conf) = @_;
    my $view = Text::Xslate->new($conf);
    $c->view($view);
}

1;
