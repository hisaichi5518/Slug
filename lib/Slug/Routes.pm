package Slug::Routes;

use strict;
use warnings;

use Plack::Util ();
use Carp ();

sub dispatch {
    my ($self, $c) = @_;

    return $c->not_found
        unless my $args = $c->routes->match($c->req->env);

    $c->req->env->{'slug.routing_args'} = $args;
    my $action    = $args->{action};
    my $namespace = $args->{namespace} || $c->routes->{namespace} || ref($c)."::Controller";

    Carp::croak("Can't find Controller or Action!")
        if !$action || !($args->{controller});

    return Plack::Util::load_class($args->{controller}, $namespace)->$action($c);
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
