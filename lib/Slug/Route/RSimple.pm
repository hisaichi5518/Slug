package Slug::Route::RSimple;
use strict;
use warnings;

use Router::Simple;
use Plack::Util ();
use Exporter::Lite;
our @EXPORT = qw(connect submapper dispatch);

{
    my $rs = Router::Simple->new;
    sub rs { $rs }
}
sub connect {
    rs->connect(@_);
}
sub submapper {
    rs->submapper(@_);
}

sub dispatch {
    my ($class, $app) = @_;
    my $req = $app->request;
    if (my $args = rs->match($req->env)) {
        $app->run_hook("after_dispatch", $app, $args);
        $req->env->{'slug.routing_args'} = $args;

        my $action = $args->{action};
        my $klass  = ref($app)."::Controller::$args->{controller}";
        Plack::Util::load_class($klass);
        return $klass->$action($app, $args);
    }
    else {
        return $app->not_found;
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
