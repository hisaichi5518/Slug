package Slug::Routes::RSimple;
use strict;
use warnings;

use parent "Router::Simple";
use Plack::Util ();

sub dispatch {
    my ($self, $c) = @_;

    if (my $args = $self->match($c->req->env)) {
        $c->req->env->{'slug.routing_args'} = $args;

        my $action     = $args->{action};
        my $namespace = $args->{namespace} || $self->{namespace} || ref($c)."::Controller";

        return $c->not_found if !$action || !($args->{controller});
        return Plack::Util::load_class($args->{controller}, $namespace)->$action($c);
    }
    else {
        return $c->not_found;
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Slug::Route::RSimple - Router::Simple

=head1 SYNOPSIS


=head1 DESCRIPTION

変わる可能性高い。

=head1 METHOD

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Router::Simple>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
