package Slug::Routes;

use strict;
use warnings;

use Plack::Util;

sub dispatch {
    my ($self, $c) = @_;

    if (my $args = $c->routes->match($c->req->env)) {
        $c->req->env->{'slug.routing_args'} = $args;
        my $action    = $args->{action};
        my $namespace = $args->{namespace} || $c->routes->{namespace} || ref($c)."::Controller";
        return $c->not_found if !$action || !($args->{controller});
        return Plack::Util::load_class($args->{controller}, $namespace)->$action($c);
    }
    else {
        return $c->not_found;
    }
}

1;
__END__

=encoding=utf-8

=pod

=head1 METHOD

=head2 dispatch

matchに渡すenvはHASHなので、Router Class はPSGIに対応している必要がある。

PSGIに対応しているのは、Router::Simple, Router::Micro

=cut
