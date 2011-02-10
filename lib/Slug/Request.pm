package Slug::Request;
use strict;
use warnings;
use parent 'Plack::Request';
use Slug::Response;

sub uri_for {
    my($self, $path, $args) = @_;
    my $uri = $self->base;
    $uri->path($uri->path . ($path || ""));
    $uri->query_form(@$args) if $args;
    $uri;
}
sub uri_with {
    my($self, $args) = @_;
    my $uri = $self->base;
    $uri->query_form(@$args) if $args;
    $uri;

}
sub new_response {
    my $self = shift;
    Slug::Response->new(@_);
}
sub args {
    shift->env->{'slug.route_args'};
}

1;
__END__

=encoding utf8

=head1 NAME

Slug::Request - Request！

=head1 SYNOPSIS

  use Slug::Request;
  my $req = Slug::Request->new($env);
  $req->uri_for('user, [name => "hisaichi5518"]);
  $req->uri_with([name => "hisaichi5518"]);
  $req->new_response(200,[],[]);
  $req->args;

=head1 DESCRIPTION

Plack::Requestを継承してるよ！そっちも見てね！

=head1 METHOD

=head2 uri_for

=head2 uri_with

=head2 new_response

=head2 args

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO



=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
