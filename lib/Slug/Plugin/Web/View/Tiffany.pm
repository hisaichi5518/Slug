package Slug::Plugin::Web::View::Tiffany;
use strict;
use warnings;

use Tiffany;

sub init {
    my ($self, $c, $conf) = @_;
    my $view = Tiffany->load(%$conf);
    $c->view(sub{ $view->render(@_); });
}

1;
